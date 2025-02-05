"
I'm a nice little tool that checks whether a document has 
- references to undeclared anchors
- duplicated anchors

I check
- figures
- math equations
- or plain references.

I use the FileCollector to support all the file input relations.
This lets the user have for example unused, broken or underway files on the side.
As soon as they are not used I do not analyse them.

I support the following API to be able to chained over a report writer:
- result/results:
- reportWriter:

# todo

when we use the checkDir or the checkFile: API, it should still do the full closure of used files (i.e. use the file collector). This is a lot simpler to understand for the user. Having a systematic approach is the way to go. 
"
Class {
	#name : 'MicReferenceChecker',
	#superclass : 'MicrodownVisitor',
	#instVars : [
		'reportWriter',
		'references',
		'duplicatedAnchors',
		'results',
		'rootDirectory',
		'listOfFiles',
		'figures',
		'anchoringEntities'
	],
	#category : 'Microdown-BookTester-Analysis',
	#package : 'Microdown-BookTester',
	#tag : 'Analysis'
}

{ #category : 'accessing' }
MicReferenceChecker >> addDuplicatedAnchor: anAnchor [

	| micResultInstance |
	micResultInstance := MicDuplicatedAnchorResult new.
	micResultInstance
		anchorLabel: anAnchor anchorLabel;
		sourceFileReference: anAnchor fromFile.
	results add: micResultInstance
]

{ #category : 'visiting' }
MicReferenceChecker >> addDuplicatedFirstAnchor: anAnchor [

	anchoringEntities do: [ :each |
		each anchorLabel = anAnchor anchorLabel ifTrue: [
			(duplicatedAnchors includes: each) ifFalse: [
				duplicatedAnchors add: each.
				self addDuplicatedAnchor: each ] ] ]
]

{ #category : 'accessing' }
MicReferenceChecker >> addReferenceToUnexistingAnchor: anAnchorReference [

	| micResultInstance |
	micResultInstance := MicReferenceToUnexistingAnchorResult new.
	micResultInstance
		anchorLabel: anAnchorReference anchorLabel;
		sourceFileReference: anAnchorReference fromFile.
	results add: micResultInstance
]

{ #category : 'accessing' }
MicReferenceChecker >> addUnexistingFigureFile: aFigure [

	| micResultInstance |
	micResultInstance := MicUndefinedFigureFileResult new.
	micResultInstance
		figureFileString: aFigure reference path;
		sourceFileReference: aFigure fromFile.
	results add: micResultInstance
]

{ #category : 'accessing' }
MicReferenceChecker >> addUnreferencedFigure: aFigure [

	| micResultInstance |
	micResultInstance := MicUnreferencedFigureResult new.
	micResultInstance
		figurePath: aFigure reference relativePath;
		anchorLabel: aFigure anchorLabel;
		sourceFileReference: aFigure fromFile.
	results add: micResultInstance
]

{ #category : 'main API' }
MicReferenceChecker >> checkDirectory: aDir [
	"Take the directory, parse all its children with microdown file parser and let the visitor visit each time then return visitor is ok which should be true if every thing is okay, the visitor turned out to treat the many documents that it visits as one, so if anchor is duplicated in another file it will detect that . "
	
	self checkList: aDir allFiles
]

{ #category : 'internal' }
MicReferenceChecker >> checkList: aCollection [
	"Pay attention checking a file in isolation is DIFFERENT from a list, because a document can have references between them and the checker should be shared amongst the documents since it collects the references."

	aCollection do: [ :each |
		| document |
		document := Microdown parseFile: each.
		document accept: self ].
	self 
		collectReferencesToUnexistingAnchors;
		collectUnreferencedFigures
		
]

{ #category : 'main API' }
MicReferenceChecker >> checkProject: aFileReference [

	| mainMic collector  |
	mainMic := Microdown parseFile: aFileReference.
	collector := MicFileCollector new.
	collector
		rootDirectory: rootDirectory;
		visit: mainMic.
	self handleUndefinedFilesFrom: collector.
	listOfFiles := collector visitedFileStrings collect: [ :file |
		               rootDirectory resolve: file ].
	self checkList: listOfFiles
]

{ #category : 'internal' }
MicReferenceChecker >> collectReferencesToUnexistingAnchors [
	"Should be called after all the docs are visited otherwise the result can be wrong."

	| badReference existingAnchorNames |
	existingAnchorNames := anchoringEntities collect: [ :each | each anchorLabel ].
	badReference := references reject: [ :anchorReference |
		                existingAnchorNames includes: anchorReference anchorLabel ].
	badReference do: [ :each | self addReferenceToUnexistingAnchor: each ]
]

{ #category : 'internal' }
MicReferenceChecker >> collectUnreferencedFigures [

	| unreferencedFigures anchorReferenceNames |
	anchorReferenceNames := references collect: [ :each | each anchorLabel ].
	unreferencedFigures := figures reject: [ :figure |  anchorReferenceNames includes: figure anchorLabel ].
	unreferencedFigures do: [ :each | self addUnreferencedFigure: each ]
]

{ #category : 'internal' }
MicReferenceChecker >> duplicatedAnchors [

	^ duplicatedAnchors
]

{ #category : 'accessing' }
MicReferenceChecker >> fileSystem: aFileSystem [

	rootDirectory := aFileSystem
]

{ #category : 'visiting' }
MicReferenceChecker >> handleAnchorOf: anElement [

	anElement hasAnchor ifFalse: [ ^ self ].
	(self hasAlreadyDefinedAs: anElement) ifTrue: [
		duplicatedAnchors add: anElement.
		self addDuplicatedAnchor: anElement.
		self addDuplicatedFirstAnchor: anElement. ].
	anchoringEntities add: anElement
]

{ #category : 'internal' }
MicReferenceChecker >> handleUndefinedFilesFrom: collector [

	collector unexistingFiles do: [ :each |
		results add: (MicUndefinedInputFileResult new 
			inputFileBlock: each ; 
			sourceFileReference: each fromFile; 
			yourself )
		
		]
]

{ #category : 'visiting' }
MicReferenceChecker >> hasAlreadyDefinedAs: anAnchor [

	| alreadyDefined |
	alreadyDefined := false. 
	anchoringEntities do: 
		 [ :each | each anchorLabel = anAnchor anchorLabel
				ifTrue: [ alreadyDefined := true ] ].
	^ alreadyDefined
]

{ #category : 'initialization' }
MicReferenceChecker >> initialize [

	super initialize.
	
	rootDirectory := FileSystem workingDirectory.
	results := OrderedCollection new.
	references := OrderedCollection new.
	figures := OrderedCollection new.
	anchoringEntities := OrderedCollection new.
	duplicatedAnchors := OrderedCollection new.
	"by default if the reporter is not set from outside
	then it shares the results of this current checker."
	reportWriter := MicAnalysisReportWriter new results: results.
]

{ #category : 'testing' }
MicReferenceChecker >> isOk [
	self flag: #fixThisLogic.
	"isOkay vs. isOk ???"
	
	^ duplicatedAnchors isEmpty and: [
		  references allSatisfy: [ :each | self hasAlreadyDefinedAs: each ] ]
]

{ #category : 'testing' }
MicReferenceChecker >> isOkay [

	^ results isEmpty
]

{ #category : 'reporting' }
MicReferenceChecker >> report [

	^ reportWriter report
]

{ #category : 'reporting' }
MicReferenceChecker >> reportSTONFormat [
	^ reportWriter reportSTONFormat
]

{ #category : 'accessing' }
MicReferenceChecker >> reportWriter [

	^ reportWriter
]

{ #category : 'accessing' }
MicReferenceChecker >> reportWriter: anObject [

	reportWriter := anObject
]

{ #category : 'accessing' }
MicReferenceChecker >> results [

	^ results
]

{ #category : 'accessing' }
MicReferenceChecker >> results: anObject [

	results := anObject
]

{ #category : 'accessing' }
MicReferenceChecker >> rootDirectory: aFileReferemce [

	rootDirectory := aFileReferemce
]

{ #category : 'internal' }
MicReferenceChecker >> unknownAnchors [
	
	| unknown ref |
	unknown := OrderedCollection new. 
	ref := references copy.
	ref do: [ :reference |
		(anchoringEntities noneSatisfy: [ :each | 
			ref anchorLabel = each anchorLabel ])
				ifTrue: [ unknown add: reference ]  ].
	^ unknown 
]

{ #category : 'visiting' }
MicReferenceChecker >> visitAnchor: anAnchor [
	"the problem with visit anchor is that it only concerns 
	@anchor and not the one of figure.
	So we should then keep a list of anchorNames for the figures, math equations
	or reify these anchor - would be nicer"
	
	| isAlready |
	isAlready := self hasAlreadyDefinedAs: anAnchor.
	isAlready ifTrue: [
		duplicatedAnchors add: anAnchor.
		self addDuplicatedAnchor: anAnchor.
		self addDuplicatedFirstAnchor: anAnchor. ].
	anchoringEntities add: anAnchor
]

{ #category : 'visiting' }
MicReferenceChecker >> visitAnchorReference: anAnchorReference [

	references add: anAnchorReference
]

{ #category : 'visiting' }
MicReferenceChecker >> visitCode: aCodeBlock [
	
	self handleAnchorOf: aCodeBlock
]

{ #category : 'visiting' }
MicReferenceChecker >> visitFigure: aFigure [
	
	figures add: aFigure. 
	self handleAnchorOf: aFigure.
	"check for unexisting file."
	(aFigure fromFile parent / aFigure reference path) exists
			ifFalse: [ self addUnexistingFigureFile: aFigure  ]
]

{ #category : 'visiting' }
MicReferenceChecker >> visitMath: aMathEnv [

	self handleAnchorOf: aMathEnv
]
