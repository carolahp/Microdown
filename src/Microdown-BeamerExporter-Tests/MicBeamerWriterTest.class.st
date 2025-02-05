Class {
	#name : 'MicBeamerWriterTest',
	#superclass : 'MicAbstractLaTexWriterTest',
	#category : 'Microdown-BeamerExporter-Tests-Slide',
	#package : 'Microdown-BeamerExporter-Tests',
	#tag : 'Slide'
}

{ #category : 'tests' }
MicBeamerWriterTest class >> testParameters [

	^ ParametrizedTestMatrix new
		  forSelector: #writer addOptions: { MicBeamerWriter };
		  forSelector: #factory addOptions: { MicMicrodownSnippetFactory };
		  forSelector: #parser addOptions: { Microdown };
		  forSelector: #newLine addOptions: { String cr . String lf };
		  yourself
]

{ #category : 'running' }
MicBeamerWriterTest >> actualClass [ 
	^ MicBeamerWriter 
]

{ #category : 'running' }
MicBeamerWriterTest >> setUp [

	super setUp.
	self parser: Microdown. 
	self 
]

{ #category : 'tests' }
MicBeamerWriterTest >> testCode [

	self writeFor: (factory codeblockNoParamBody: 'this is a code').
	self assert: writer contents equals: '\begin{listing}{}', newLine ,
													'this is a code', newLine ,
													'\end{listing}', newLine
]

{ #category : 'tests' }
MicBeamerWriterTest >> testCodeWithCaptionIgnoresCaption [
	
	self writeFor: (factory codeblock: 'caption=Pharo is **cool**' body: 'this is a code').
	self 
		assert: writer contents 
		equals: '\begin{listing}{}', newLine ,
													'this is a code', newLine ,
													'\end{listing}', newLine
]

{ #category : 'tests' }
MicBeamerWriterTest >> testCodeWithLabelIgnoresLabel [

	self writeFor: (factory codeblock: 'label=Pharo' body: 'this is a code').
	self 
		assert: writer contents 
		equals: '\begin{listing}{}', newLine ,
'this is a code', newLine ,
'\end{listing}', newLine
]

{ #category : 'tests' }
MicBeamerWriterTest >> testCodeWithPharoCode [

	self writeFor: '
```
| a |
a := 40 + 2.
^ a
```
'.
	self assert: writer contents equals: '\begin{listing}{}', newLine ,
													'| a |', newLine ,
													'a := 40 + 2.', newLine ,
													'^ a', newLine ,
													'\end{listing}', newLine
]

{ #category : 'tests' }
MicBeamerWriterTest >> testColumn [

	self writeFor: factory columnSample.
	self 
		assert: writer contents 
		equals:'\begin{column}{0.42\textwidth}', newLine , newLine, 
'this is a \textbf{text}', newLine ,
'\end{column}', newLine, newLine
]

{ #category : 'tests' }
MicBeamerWriterTest >> testColumns [

	self writeFor: factory columnsSample.
	self 
		assert: writer contents 
		equals:'\begin{columns}', newLine ,
'\end{columns}', newLine , newLine
]

{ #category : 'tests' }
MicBeamerWriterTest >> testColumnsWithChildren [

	self writeFor: factory columnsWithChildrenSample.
	self assert: writer contents equals:'\begin{columns}', newLine ,
'\begin{column}{0.42\textwidth}', newLine , newLine ,
'this is a \textbf{text}', newLine ,
'\end{column}', newLine , newLine ,
'\begin{column}{0.42\textwidth}', newLine, newLine,
'this is a \textbf{text}', newLine ,
'\end{column}', newLine , newLine ,
'\end{columns}', newLine , newLine
]

{ #category : 'tests - figure/link' }
MicBeamerWriterTest >> testFigure [

	self writeFor: factory figureSample.
	self assert: writer contents equals: newLine,
'\begin{center}', newLine ,
'\includegraphics[width=0.8\textwidth]{/anUrl}\end{center}', newLine, newLine
]

{ #category : 'tests - figure/link' }
MicBeamerWriterTest >> testFigureBold [
	"in beamer we do not display caption so bld and the rest goes away."
	self writeFor: factory figureBoldSample.
	self assert: writer contents equals: newLine ,
'\begin{center}', newLine ,
'\includegraphics[width=0.8\textwidth]{/anUrl}\end{center}', newLine , newLine
]

{ #category : 'tests - figure/link' }
MicBeamerWriterTest >> testFigureRealSample [

	self writeFor: factory figureRealSample.
	self assert: writer contents equals: newLine ,
'\begin{center}', newLine ,
'\includegraphics[width=0.8\textwidth]{figures/logo.png}\end{center}', newLine , newLine
]

{ #category : 'tests' }
MicBeamerWriterTest >> testFrameWithoutOption [

	self
		parse: '<!slide|title=Slide title', newLine ,
						'Presentation text', newLine
		andCheckWeGet: newLine ,
'\begin{frame}[fragile]', newLine ,
newLine ,
'\frametitle{Slide title}', newLine ,
newLine ,
'Presentation text', newLine ,
'\end{frame}', newLine, newLine
]
