Class {
	#name : 'MicLinkBlockTest',
	#superclass : 'MicBlockTest',
	#instVars : [
		'splitterClass',
		'link'
	],
	#category : 'Microdown-Tests-Parser',
	#package : 'Microdown-Tests',
	#tag : 'Parser'
}

{ #category : 'functions' }
MicLinkBlockTest >> linkBoldSample [

	^ '
[**Foo**](/anUrl)
'
]

{ #category : 'functions' }
MicLinkBlockTest >> linkItalicSample [

	^ '
[_Foo_](/anUrl)
'
]

{ #category : 'functions' }
MicLinkBlockTest >> linkMonospaceSample [

	^ '
[`Foo`](/anUrl)
'
]

{ #category : 'functions' }
MicLinkBlockTest >> linkNestedSample [

	^ '
[**_Foo_**](/anUrl)
'
]

{ #category : 'functions' }
MicLinkBlockTest >> linkSample [
	^ '
[Foo](/anUrl)
'
]

{ #category : 'functions' }
MicLinkBlockTest >> linkStrikeSample [

	^ '
[~Foo~](/anUrl)
'
]

{ #category : 'tests - link' }
MicLinkBlockTest >> parseLink: aString [
	"Parse aString containing Microdown link to a MicLinkBlock"

	^ (self parser parse: aString) children first children first.
]

{ #category : 'running' }
MicLinkBlockTest >> setUp [

	super setUp.
	parser := self parser. 
	splitterClass := MicInlineParser
]

{ #category : 'tests' }
MicLinkBlockTest >> subjectClass [ 
	^ MicHorizontalLineBlock
]

{ #category : 'tests' }
MicLinkBlockTest >> testFullName [

	link := self parseLink: self linkSample.
	self assert: link reference fullName equals: '/anUrl'
]

{ #category : 'tests' }
MicLinkBlockTest >> testHasArguments [
	| lk |
	lk := (splitterClass new parse: '[caption with space and dot...](https://github.com/pillar-markup/Microdown/runs/4336482137?check_suite_focus=true  width=80&anchor=bla)') first.
	
	self assert: lk hasArguments.
	self assert: lk bodyString equals: 'caption with space and dot...'
	
	
]

{ #category : 'tests - link' }
MicLinkBlockTest >> testLinkAPIToAccessText [

	link := self parseLink: self linkSample.
	self assert: link class equals: MicLinkBlock.
	self assert: link url equals: '/anUrl'
]

{ #category : 'tests - link' }
MicLinkBlockTest >> testLinkBoldAPIToAccessText [

	link := self parseLink: self linkBoldSample.
	self assert: link class equals: MicLinkBlock.
	self assert: link children first class equals: MicBoldFormatBlock.
	self
		assert: link children first children first class
		equals: MicTextBlock.

	self assert: link url equals: '/anUrl'
]

{ #category : 'tests - link' }
MicLinkBlockTest >> testLinkCreatesInnerText [

	link := self parseLink: '[ab](https://ab.com)'.
	self assert: link class equals: MicLinkBlock.
	self assert: link url equals: 'https://ab.com'
]

{ #category : 'tests - link' }
MicLinkBlockTest >> testLinkItalicAPIToAccessText [

	link := self parseLink: self linkItalicSample.
	self assert: link class equals: MicLinkBlock.
	self assert: link children first class equals: MicItalicFormatBlock.
	self
		assert: link children first children first class
		equals: MicTextBlock.

	self assert: link url equals: '/anUrl'
]

{ #category : 'tests' }
MicLinkBlockTest >> testOneUrl [

	| lk |
	lk := (MicInlineParser new parse: '[Mooc](https://advanced-design-mooc.pharo.org)') first.

	self assert: lk bodyString equals: 'Mooc'.
	self assert: lk url equals: 'https://advanced-design-mooc.pharo.org'
]

{ #category : 'tests' }
MicLinkBlockTest >> testPrintOn [

	link := (splitterClass new parse: '[caption](http://www.pharo.org)')
		        first.
	self
		assert: link asString
		equals: 'Link[ Text(caption) ](http://www.pharo.org)'
]

{ #category : 'tests' }
MicLinkBlockTest >> testTwoUrls [

	| lk |
	lk := (MicInlineParser new parse: '[https://advanced-design-mooc.pharo.org](https://advanced-design-mooc.pharo.org)') first.

	self assert: lk bodyString equals: 'https://advanced-design-mooc.pharo.org'.
	self assert: lk url equals: 'https://advanced-design-mooc.pharo.org'
]

{ #category : 'tests' }
MicLinkBlockTest >> testTwoUrlsWithMicrodownParser [

	| lk |
	lk := (parser parse: '[https://advanced-design-mooc.pharo.org](https://advanced-design-mooc.pharo.org)') children first children first.

	self assert: lk bodyString equals: 'https://advanced-design-mooc.pharo.org'.
	self assert: lk url equals: 'https://advanced-design-mooc.pharo.org'
]

{ #category : 'tests' }
MicLinkBlockTest >> testUrl [

	link := (splitterClass new parse: '[caption](http://www.pharo.org:8080)') first.
	self assert: link url equals: 'http://www.pharo.org:8080'.
	
	self assert: link children first bodyString equals: 'caption'
]
