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
	
	| rootNode m|
	((self randomElementOf: (0 to: 10) )< 2)
	 ifTrue: [  
		rootNode := self returnNode.
		m := self newMethod.
		rootNode addChild: m.
		(self createNewIndividualRoot: m depth: 2).
		^ rootNode]
	 ifFalse: [ rootNode := self newMethod ].
	self createNewIndividualRoot: rootNode depth: 2.
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
	n := rootNode type. "number of args of the method"
	
	rootNode addChild: (self respondsMethod: rootNode). "object that call the method"
	
	(depth = 1) 
		ifTrue: [ 1 to: n do: 
			[ :i | 
			rootNode addChild: self newTerminalVariable].
			^self].
		
	1 to: n do: [ :i |
		c := self randomElementOf: (1 to: 2).
		(c = 1) ifTrue: [ rootNode addChild: self newTerminalVariable ].
		(c = 2) ifTrue: [ 
			f := self methodNode.
			rootNode addChild: f.
			self createNewIndividualRoot: f depth: depth - 1  ]. ]
		
	
	


]

{ #category : #accessing }
GPAbstractCodeGeneratorConfiguration >> methodNode [ 
	| res mt msplit t|
	mt := (self pickRandomMethod: (self methods) with: (self randomElementOf: (0 to: (self sumWeightsAllMethods)) )).
	t := mt name.
	res := GPNode new.

	msplit := (t asString) splitOn: ':'.
	(msplit size = 1)
	ifTrue:[res printBlock: [ :children :context | '(' , (children first printUsing: context), ' ', t asString , ')'].]
	ifFalse:[
		res printBlock: [:children :context | 
			|ans|
			ans:= (children first printUsing: context), ' '.
		msplit doWithIndex: [:key :i | (i < msplit size) ifTrue: [ans:= ans , key , ': ' , ((children at: (i+1)) printUsing: context) , ' ']].
		'(' , ans , ')']].

	res type: (mt numArgs).
	res name: t.
	^ res 
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
	^ self methodNode
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
	methods do: [ :mw | acc := acc + (mw weight).
		(acc >= ran) ifTrue: [ ^ mw ]. ].
	
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

{ #category : #'as yet unclassified' }
GPAbstractCodeGeneratorConfiguration >> returnNode [
	| res |
	res := GPNode new.
	
	res printBlock: [ :children :context | '^ ' , (children first printUsing: context), ' '].
	res type: 'return'.
	res name: 'return'.
	^ res 
]

{ #category : #'as yet unclassified' }
GPAbstractCodeGeneratorConfiguration >> sumWeightsAllMethods [ 
	self subclassResponsibility 
]

{ #category : #accessing }
GPAbstractCodeGeneratorConfiguration >> variables [ 
	self subclassResponsibility 
]
