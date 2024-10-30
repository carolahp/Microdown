"
When there is no tag other than none or language, does not verify the code block.
"
Class {
	#name : 'MicBookTesterNullStrategy',
	#superclass : 'MicBookTesterStrategy',
	#category : 'Microdown-BookTester-Analysis',
	#package : 'Microdown-BookTester',
	#tag : 'Analysis'
}

{ #category : 'hook' }
MicBookTesterNullStrategy class >> handleKey [

	^ #language

]

{ #category : 'main API' }
MicBookTesterNullStrategy >> verify: aMicCodeBlock [ 
	

	
]