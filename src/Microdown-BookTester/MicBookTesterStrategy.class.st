Class {
	#name : 'MicBookTesterStrategy',
	#superclass : 'Object',
	#instVars : [
		'results'
	],
	#category : 'Microdown-BookTester-Analysis',
	#package : 'Microdown-BookTester',
	#tag : 'Analysis'
}

{ #category : 'hook' }
MicBookTesterStrategy class >> handleKey [

	^ self subclassResponsibility 

]

{ #category : 'accessing' }
MicBookTesterStrategy >> results: aCollection [ 
	results := aCollection
]
