Class {
	#name : 'MicRawBlockTest',
	#superclass : 'MicBlockTest',
	#category : 'Microdown-Tests-Parser',
	#package : 'Microdown-Tests',
	#tag : 'Parser'
}

{ #category : 'tests' }
MicRawBlockTest >> subjectClass [
	^ MicRawBlock  
]

{ #category : 'tests' }
MicRawBlockTest >> testASimpleRawParagaaph [
	| mic |
	mic := (parser parse: '<title> 
No idea what it is :)
</title>') children first.
	self assert: mic class equals: MicRawParagraphBlock. 
	self assert: mic label equals: 'title'.

]

{ #category : 'tests' }
MicRawBlockTest >> testRaw [

	| root |
	root := parser parse: 'it should be in a paragraph {{_Foo_}}'.
	self assert: root children first class equals: MicParagraphBlock.
	self
		assert: root children first children second class
		equals: MicRawBlock
]
