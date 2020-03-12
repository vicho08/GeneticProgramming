Class {
	#name : #GPAbstractArithmeticConfiguration,
	#superclass : #GPConfiguration,
	#category : #'GeneticProgramming-Core'
}

{ #category : #'instance creation' }
GPAbstractArithmeticConfiguration >> multNode [

"
	c = 1 ifTrue: [ ^ self newTerminalAdd ].
	c = 2 ifTrue: [ ^ self newTerminalMult ].
	c = 3 ifTrue: [ ^ self newTerminalSub ].
"
	| res |
	res := GPNode new.
	res printBlock: [ :children :context | '(', (children first printUsing: context), ' * ', (children second printUsing: context), ')' ].
	res evaluationBlock: [ :children :context | 
		(children first evaluateUsing: context) * (children second evaluateUsing: context) ].
	^ res
]

{ #category : #hooks }
GPAbstractArithmeticConfiguration >> newFunction [
	"This method has to return a new function"

	| c |
	c := (self randomElementOf: (1 to: 3)).
	c = 1 ifTrue: [ ^ self sumNode ].
	c = 2 ifTrue: [ ^ self multNode ].
	c = 3 ifTrue: [ ^ self subNode ].
]

{ #category : #hooks }
GPAbstractArithmeticConfiguration >> newTerminal [
	"This method has to return a new function"

	"Could be x or a number"
	^ self randomBoolean
		ifTrue: [ self newTerminalX ] 
		ifFalse: [ self newTerminalNumber ]
]

{ #category : #'instance creation' }
GPAbstractArithmeticConfiguration >> newTerminalNumber [
	| res t |
	t := self randomElementOf: #(1 2 3 4 5 6).
	res := GPNode new.
	res printBlock: [ :children :context | t asString ].
	res evaluationBlock: [ :children :context | t ].
	^ res
]

{ #category : #operations }
GPAbstractArithmeticConfiguration >> newTerminalX [
	| res |
	res := GPNode new.
	res printBlock: [ :children :context | 'x' ].
	res evaluationBlock: [ :children :context | context at: #x ].
	^ res
]

{ #category : #'instance creation' }
GPAbstractArithmeticConfiguration >> number: t [
	| res |
	res := GPNode new.
	res type: t.
	res printBlock: [ :children :context | t asString ].
	res evaluationBlock: [ :children :context | t ].
	^ res
]

{ #category : #'instance creation' }
GPAbstractArithmeticConfiguration >> subNode [

"
	c = 1 ifTrue: [ ^ self newTerminalAdd ].
	c = 2 ifTrue: [ ^ self newTerminalMult ].
	c = 3 ifTrue: [ ^ self newTerminalSub ].
"
	| res |
	res := GPNode new.
	res printBlock: [ :children :context | '(', (children first printUsing: context), ' - ', (children second printUsing: context), ')' ].
	res evaluationBlock: [ :children :context | 
		(children first evaluateUsing: context) - (children second evaluateUsing: context) ].
	^ res
]

{ #category : #operations }
GPAbstractArithmeticConfiguration >> sumNode [

"
	c = 1 ifTrue: [ ^ self newTerminalAdd ].
	c = 2 ifTrue: [ ^ self newTerminalMult ].
	c = 3 ifTrue: [ ^ self newTerminalSub ].
"
	| res |
	res := GPNode new.
	res printBlock: [ :children :context | 
		'(', (children first printUsing: context), ' + ', (children second printUsing: context), ')' ].
	res evaluationBlock: [ :children :context | 
		(children first evaluateUsing: context) + (children second evaluateUsing: context) ].
	^ res
]

{ #category : #'instance creation' }
GPAbstractArithmeticConfiguration >> variable: aVariableNameAsString [
	| res |
	res := GPNode new.
	res printBlock: [ :children :context | aVariableNameAsString asString ].
	res evaluationBlock: [ :children :context | context at: aVariableNameAsString asSymbol ].
	^ res
]
