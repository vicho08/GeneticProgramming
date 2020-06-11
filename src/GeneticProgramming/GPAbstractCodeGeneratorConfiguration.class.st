Class {
	#name : #GPAbstractCodeGeneratorConfiguration,
	#superclass : #GPConfiguration,
	#category : #'GeneticProgramming-Core'
}

{ #category : #operations }
GPAbstractCodeGeneratorConfiguration >> assigmentNode [
"
x := ops
Replace the value associated with x with the result of 'ops'
"
	| res |
	res := GPNode new.
	res printBlock: [ :children :context | 
		(children first printUsing: context), ' := ', (children second printUsing: context), ''].
	res evaluationBlock: [ :children :context | 
		context at: ((children first printUsing: context) asSymbol) put: (children second evaluateUsing: context)].
	res type: 'assigment'.
	^ res
]

{ #category : #'instance creation' }
GPAbstractCodeGeneratorConfiguration >> binaryMethodNode [
	| res t|
	t := self randomElementOf: (self binaryMethods).
	res := GPNode new.
	res printBlock: [ :children :context | '(' , (children first printUsing: context), ' ', t asString , ' ' , (children second printUsing: context) , ')'].
	res evaluationBlock: [ :children :context | (children first evaluateUsing: context) perform: t with: (children second evaluateUsing: context)].
	res type: 'binaryMethod'.
	^ res
]

{ #category : #accessing }
GPAbstractCodeGeneratorConfiguration >> binaryMethods [
	self subclassResponsibility 
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
	self createNewIndividualRoot: rootNode depth:4.
	^ rootNode
]

{ #category : #'private-operation' }
GPAbstractCodeGeneratorConfiguration >> createNewIndividualRoot: rootNode depth: depth [
"
create a simple assigment node:  var := expr 

assigment 	:= var : expr
expr 			:= unary | binary | var
unary 			:= expr : unaryMethod
binary 		:= expr : binaryMethod : expr

var 			:= x | y | ...
unaryMethod 	:= sqrt | squared | ...
binaryMethod:= + | - | ...
"
	| f c n| 
	(rootNode sameType: (self assigmentNode )) ifTrue: [rootNode addChild: self newTerminalVariable].
	
	depth = 1 ifTrue: [ 
		(rootNode sameType: (self unaryMethodNode)) ifTrue:
		 [ rootNode addChild: self newTerminalVariable.
			^ self].
		(rootNode sameType: (self binaryMethodNode)) ifTrue:
		 [ 1 to: 2 do: [:i | rootNode addChild: self newTerminalVariable.].  ^ self ]].
	n := 1.
	(rootNode sameType: (self binaryMethodNode)) ifTrue: [ n :=2 ].
	1 to: n do:[ :i |
	c := (self randomElementOf: (1 to: 3)).
	c = 1 ifTrue: [ rootNode addChild: self newTerminalVariable].
	c = 2 ifTrue: [ 
		f:= self unaryMethodNode.
		rootNode addChild: f.
		self createNewIndividualRoot: f depth: depth - 1. ].
	c= 3 ifTrue: [
		f := self binaryMethodNode.
		rootNode addChild: f.
		self createNewIndividualRoot: f depth: depth - 1  ]].


]

{ #category : #accessing }
GPAbstractCodeGeneratorConfiguration >> methods [
	self subclassResponsibility 
]

{ #category : #operations }
GPAbstractCodeGeneratorConfiguration >> mutate: individual [
	| nodeToMutate source |
	nodeToMutate := self randomElementOf: (individual withAllChildren select: [ :n | n children isEmpty ]).
	source := self newTerminalVariable.
	nodeToMutate evaluationBlock: source evaluationBlock.
	nodeToMutate printBlock: source printBlock.
	nodeToMutate type: source type.
]

{ #category : #'instance creation' }
GPAbstractCodeGeneratorConfiguration >> newMethod [
	| c |
	c := (self randomElementOf: (1 to: 2)).
	c = 1 ifTrue: [ ^ self unaryMethodNode ].
	c = 2 ifTrue: [ ^ self binaryMethodNode  ].
]

{ #category : #'instance creation' }
GPAbstractCodeGeneratorConfiguration >> newTerminalMethod [
	| res t|
	t := self randomElementOf: (self unaryMethods).
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
	res evaluationBlock: [ :children :context | context at: t]  .
	res type: 'variable'.
	^ res
]

{ #category : #'instance creation' }
GPAbstractCodeGeneratorConfiguration >> unaryMethodNode [
	| res t|
	t := self randomElementOf: (self unaryMethods).
	res := GPNode new.
	res printBlock: [ :children :context | '(',(children first printUsing: context), ' ', t asString , ')'].
	res evaluationBlock: [ :children :context | (children first evaluateUsing: context) perform: t].
	res type: 'unaryMethod'.
	^ res
]

{ #category : #accessing }
GPAbstractCodeGeneratorConfiguration >> unaryMethods [
	self subclassResponsibility 
]

{ #category : #accessing }
GPAbstractCodeGeneratorConfiguration >> variables [ 
	self subclassResponsibility 
]
