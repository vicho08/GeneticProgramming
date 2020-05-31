Class {
	#name : #GPAbstractCodeGeneratorConfiguration,
	#superclass : #GPConfiguration,
	#category : #'GeneticProgramming-Core'
}

{ #category : #'as yet unclassified' }
GPAbstractCodeGeneratorConfiguration >> assigmentNode [
"
x := y method
Replace the value associated with x with the result that y sends the message 'method'
"
	| res |
	res := GPNode new.
	res printBlock: [ :children :context | 
		(children first printUsing: context), ' := (', (children second printUsing: context), ' ', (children third printUsing: context), ')'].
	res evaluationBlock: [ :children :context | 
		context at: (children first evaluateUsing: context) put: ((children third evaluateUsing: context) value: (context at: (children second evaluateUsing: context)))].
	res type: 'conditional'.
	^ res
]

{ #category : #operations }
GPAbstractCodeGeneratorConfiguration >> createNewIndividual [
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
	rootNode := self assigmentNode.
	self createNewIndividualRoot: rootNode depth: 1.
	^ rootNode
]

{ #category : #'private-operation' }
GPAbstractCodeGeneratorConfiguration >> createNewIndividualRoot: rootNode depth: depth [
"
create a simple assigment node:  anObject := otherObject aMethod
"
	rootNode addChild: self newTerminalVariable.
	rootNode addChild: self newTerminalVariable.
	rootNode addChild: self newTerminalMethod.
	^ self. 

]

{ #category : #accessing }
GPAbstractCodeGeneratorConfiguration >> methods [
	self subclassResponsibility 
]

{ #category : #operations }
GPAbstractCodeGeneratorConfiguration >> mutate: individual [
	| nodeToMutate source |
	nodeToMutate := self randomElementOf: (individual withAllChildren select: [ :n | n children isEmpty ]).
	source := 
		nodeToMutate type = 'method'
		 	ifTrue: [self newTerminalMethod]
			ifFalse: [ self newTerminalVariable].
	nodeToMutate evaluationBlock: source evaluationBlock.
	nodeToMutate printBlock: source printBlock.
	nodeToMutate type: source type.
]

{ #category : #'instance creation' }
GPAbstractCodeGeneratorConfiguration >> newTerminalMethod [
	| res t|
	t := self randomElementOf: (self methods).
	res := GPNode new.
	res printBlock: [ :children :context | t asString ].
	res evaluationBlock: [ :children :context | [ :object | object perform: t]]  .
	res type: 'method'.
	^ res
]

{ #category : #'instance creation' }
GPAbstractCodeGeneratorConfiguration >> newTerminalVariable [
	| res t|
	t := self randomElementOf: (self variables).
	res := GPNode new.
	res printBlock: [ :children :context | t asString ].
	res evaluationBlock: [ :children :context | t asSymbol]  .
	res type: 'variable'.
	^ res
]

{ #category : #accessing }
GPAbstractCodeGeneratorConfiguration >> variables [ 
	self subclassResponsibility 
]
