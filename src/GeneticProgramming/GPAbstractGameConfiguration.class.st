Class {
	#name : #GPAbstractGameConfiguration,
	#superclass : #GPConfiguration,
	#category : #'GeneticProgramming-Core'
}

{ #category : #operations }
GPAbstractGameConfiguration >> andNode [
"
	return a node that represent a conditional statement if ... then ... else ...
"
	| res |
	res := GPNode new.
	res printBlock: [ :children :context | 
		'(', (children first printUsing: context), ' & ', (children second printUsing: context), ')' ].
	res evaluationBlock: [ :children :context | 
		(children first evaluateUsing: context) value and: (children second evaluateUsing: context) value].
	res type: 'boolean'.
	^ res
]

{ #category : #'instance creation' }
GPAbstractGameConfiguration >> boolean: t [
	| res |
	res := GPNode new.
	res type: t.
	res printBlock: [ :children :context | t asString ].
	res evaluationBlock: [ :children :context | t ].
	^ res
]

{ #category : #operations }
GPAbstractGameConfiguration >> conditionalNode [
"
	return a node that represent a conditional statement if ... then ... else ...
"
	| res |
	res := GPNode new.
	res printBlock: [ :children :context | 
		'(if ', (children first printUsing: context), ' then ', (children second printUsing: context), ' else ', (children third printUsing: context), ')' ].
	res evaluationBlock: [ :children :context | 
		(children first evaluateUsing: context)
  			ifTrue: [(children second evaluateUsing: context)]
  			ifFalse: [(children third evaluateUsing: context)]].
	res type: 'conditional'.
	^ res
]

{ #category : #operations }
GPAbstractGameConfiguration >> createNewIndividual [
	"Return a new individual"
	
	"
	| i b |
	i := GPAritConfiguration new createNewIndividual.
	b := RTMondrian new.
	b shape label text: #type.
	b nodes: i withAllChildren.
	b edges connectToAll: #children.
	b layout tree.
	b
	"
	
	| rootNode |
	rootNode := self conditionalNode.
	self createNewIndividualRoot: rootNode depth: 3.
	^ rootNode
]

{ #category : #operations }
GPAbstractGameConfiguration >> createNewIndividualRoot: rootNode depth: depth [
	rootNode addChild: (self newNodeBoolean: 2).
	depth = 1 ifTrue: [ 
		1 to: 2 do: [ :i |
			rootNode addChild: self newTerminalAction ]. 
		^ self ].
	
	"50% to change a terminal"
	1 to: 2 do: [ :i |
		self randomBoolean
			ifTrue: [ 
				| f |
				f := self conditionalNode.
				rootNode addChild: f.
				self createNewIndividualRoot: f depth: depth - 1 ]
			ifFalse: [ rootNode addChild: self newTerminalAction ] ] 
]

{ #category : #operations }
GPAbstractGameConfiguration >> mutate: individual [
	| nodeToMutate source |
	nodeToMutate := self randomElementOf: (individual withAllChildren select: [ :n | n children isEmpty ]).
	source := 
		nodeToMutate type = 'boolean action'
		 	ifTrue: [self newTerminalBoolean]
			ifFalse: [ self newTerminalAction ].
	nodeToMutate evaluationBlock: source evaluationBlock.
	nodeToMutate printBlock: source printBlock.
	nodeToMutate type: source type.
]

{ #category : #hooks }
GPAbstractGameConfiguration >> newNodeBoolean: depth [
	"This method has to return a new function"
	self subclassResponsibility 
]

{ #category : #hooks }
GPAbstractGameConfiguration >> newTerminalAction [
	"This method has to return a new function"
	self subclassResponsibility 
]

{ #category : #'instance creation' }
GPAbstractGameConfiguration >> newTerminalBoolean [ 
	"This method has to return a new boolean node"

	"Could be true or false"
	|res b|
	b := self randomBoolean.
	res := GPNode new.
	res printBlock: [ :children :context | b asString ].
	res evaluationBlock: [ :children :context | b ].
]

{ #category : #hooks }
GPAbstractGameConfiguration >> numberOfGenerations [ 
	^100
]

{ #category : #operations }
GPAbstractGameConfiguration >> orNode [
"
	return a node that represent operation boolean AND
"
	| res |
	res := GPNode new.
	res printBlock: [ :children :context | 
		'(', (children first printUsing: context), ' || ', (children second printUsing: context), ')' ].
	res evaluationBlock: [ :children :context | 
		(children first evaluateUsing: context) value or: (children second evaluateUsing: context) value].
	res type: 'boolean'.
	^ res
]
