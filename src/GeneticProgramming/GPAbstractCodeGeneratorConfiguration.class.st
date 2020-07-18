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
	t := (self pickRandomMethod: (self binaryMethods ) with: (self randomElementOf: (0 to: (self sumWeightsBinary)) )).
	res := GPNode new.
	res printBlock: [ :children :context | '(' , (children first printUsing: context), ' ', t asString , ' ' , (children second printUsing: context) , ')'].
	res evaluationBlock: [ :children :context | (children first evaluateUsing: context) perform: t with: (children second evaluateUsing: context)].
	res type: 'binaryMethod'.
	res name: t.
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
	
	| rootNode c|
	c:= 2.
	(c=1) ifTrue: [  rootNode := self assigmentNode].
	(c=2) ifTrue: [ rootNode := self newMethod ].
	self createNewIndividualRoot: rootNode depth:2.
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
		  [ rootNode addChild: (self respondsMethod: rootNode).
			^ self].
		(rootNode sameType: (self binaryMethodNode)) ifTrue:
		 [ 1 to: 2 do: [:i |  rootNode addChild: (self respondsMethod: rootNode)].  ^ self ]].
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
	| nodeToMutate newInd|
	
	nodeToMutate := self createNewIndividual.
	newInd := individual crossOverWith: nodeToMutate.
	individual children: newInd children.
	individual printBlock: newInd printBlock.
	individual evaluationBlock: newInd evaluationBlock.
	individual type: newInd type.
	individual name: newInd name.
	individual fitnessCache: nil.
]

{ #category : #'instance creation' }
GPAbstractCodeGeneratorConfiguration >> newMethod [
	| c |
	c := (self randomElementOf: (0 to: (self sumWeightsUnary+ self sumWeightsBinary ))).
	(c <= (self sumWeightsUnary )) 
		ifTrue: [ ^ self unaryMethodNode ]
		ifFalse: [ ^ self binaryMethodNode  ].
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
GPAbstractCodeGeneratorConfiguration >> newTerminalRespondsVariable [
	| res t|
	(self respondsVariables isEmpty) ifTrue:[ ^self newTerminalVariable  ].
	t := self randomElementOf: (self respondsVariables).
	res := GPNode new.
	res printBlock: [ :children :context | t asString ].
	res evaluationBlock: [ :children :context | context at: t]  .
	res type: 'variable'.
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

{ #category : #'as yet unclassified' }
GPAbstractCodeGeneratorConfiguration >> pickRandomMethod: methods with: ran [ 
	|acc|
	acc:= 0.
	methods do: [ :mw | acc := acc + (mw at: 2).
		(acc >= ran) ifTrue: [ ^ mw at: 1 ]. ].
	
]

{ #category : #'as yet unclassified' }
GPAbstractCodeGeneratorConfiguration >> respondsMethod: rootNode [
	(rootNode  children isEmpty)
	ifFalse: [self newTerminalVariable  ].
	self restartRespondsVariables .
	self variables do: [ :v | ((self types at: v) respondsTo:  rootNode name)
		ifTrue: [ self respondsVariables add: v ] ].
	
	^ self newTerminalRespondsVariable
]

{ #category : #'as yet unclassified' }
GPAbstractCodeGeneratorConfiguration >> respondsVariables [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
GPAbstractCodeGeneratorConfiguration >> restartRespondsVariables [
	self subclassResponsibility
]

{ #category : #accessing }
GPAbstractCodeGeneratorConfiguration >> sumWeightsBinary [ 
	self subclassResponsibility 
]

{ #category : #accessing }
GPAbstractCodeGeneratorConfiguration >> sumWeightsUnary [ 
	self subclassResponsibility 
]

{ #category : #'instance creation' }
GPAbstractCodeGeneratorConfiguration >> unaryMethodNode [
	| res t|
	t := (self pickRandomMethod: (self unaryMethods ) with: (self randomElementOf: (0 to: (self sumWeightsUnary)) )).
	res := GPNode new.
	res printBlock: [ :children :context | '(',(children first printUsing: context), ' ', t asString , ')'].
	res evaluationBlock: [ :children :context | (children first evaluateUsing: context) perform: t].
	res type: 'unaryMethod'.
	res name: t.
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
