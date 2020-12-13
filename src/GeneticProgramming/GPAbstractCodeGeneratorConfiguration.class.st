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
	res := GPNodeGeneratorCode new.
	res printBlock: [ :children :context | 
		(children first printUsing: context), ' := ', (children second printUsing: context), ''].
	res evaluationBlock: [ :children :context | 
		context at: ((children first printUsing: context) asSymbol) put: (children second evaluateUsing: context)].
	res type: 'assigment'.
	res name: 'assigment'.
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
	
	| rootNode m c|
	c:= self randomElementOf: (0 to: 99).
	 (c<63) ifTrue: [  
		rootNode := self returnNode.
		m := self newMethod.
		rootNode addChild: m.
		(self createNewIndividualRoot: m depth: 3).
		^ rootNode].
	 (c<89) ifTrue: [ rootNode := self newMethod ].
	(c> 88 and: (c<100)) ifTrue: [ rootNode := self assigmentNode  ].  
	self createNewIndividualRoot: rootNode depth: 3.
	^ rootNode
]

{ #category : #'private-operation' }
GPAbstractCodeGeneratorConfiguration >> createNewIndividualRoot: rootNode depth: depth [ 
"
expr 			:= return | call
return 		:= ^ call
call  			:= ((call) method [: args]  | Obj method [:args] 
args 			:= call | Obj
"
	|f n| 
	n := rootNode type. "number of args of the method or assigment"
	
	(n = 'assigment') ifTrue: [ n:= 0.
		rootNode addChild: self newTerminalVariableWithoutSelf].
	
	(depth = 1) 
		ifTrue: [ 0 to: n do: 
			[ :i | 
			rootNode addChild: self newTerminalVariable].
			^self].
		
	0 to: n do: [ :i |
		((self randomElementOf: (0 to: 9)) <3)
		ifTrue: [ 
			rootNode addChild: self newTerminalVariable ]
		ifFalse: [ 
			f := self methodNode.
			rootNode addChild: f.
			self createNewIndividualRoot: f depth: depth - 1  ]. ]
		
	
	


]

{ #category : #accessing }
GPAbstractCodeGeneratorConfiguration >> methodNode [ 
	| res mt msplit t|
	mt := (self pickRandomMethod: (self methods) with: (self randomElementOf: (0 to: (self sumWeightsAllMethods)) )).
	t := mt name.
	res := GPNodeGeneratorCode new.

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
	[individual verifyVariable: newInd] whileTrue:[
	nodeToMutate := self createNewIndividual.
	newInd := individual crossOverWith: nodeToMutate.
	].
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
GPAbstractCodeGeneratorConfiguration >> newSenderVariable: aNameMethod [
	| res vt t st|
	st := (self methods) select: [ : m | (m name) = (aNameMethod asSymbol) ].
	vt := self randomElementOf: ((st at: 1) sendersCache).
	t := vt name.
	res := GPNodeGeneratorCode new.
	res printBlock: [ :children :context | t asString ].
	res evaluationBlock: [ :children :context | context at: t]  .
	res type: 'variable'.
	^ res
]

{ #category : #'instance creation' }
GPAbstractCodeGeneratorConfiguration >> newTerminalVariable [
	| res vt t|
	vt := (self pickRandomVariable: (self variables) with: (self randomElementOf: (0 to: (self sumWeightsAllVariables)))).
	t := vt name.
	res := GPNodeGeneratorCode new.
	res printBlock: [ :children :context | t asString ].
	res evaluationBlock: [ :children :context | context at: t]  .
	res type: 'variable'.
	^ res
]

{ #category : #'instance creation' }
GPAbstractCodeGeneratorConfiguration >> newTerminalVariableWithoutSelf [
	| res vt t|
	vt :=(self pickRandomVariable: (self variables) with: (self randomElementOf: (0 to: (self sumWeightsAllVariables)))).
	t := vt name.
	
	"Variable cant not be self"
	[ t = #self ] whileTrue: [ 
	 vt :=(self pickRandomVariable: (self variables) with: (self randomElementOf: (0 to: (self sumWeightsAllVariables)))).
	t := vt name.].
	
	
	res := GPNode new.
	res printBlock: [ :children :context | t asString ].
	res evaluationBlock: [ :children :context | context at: t]  .
	res type: 'variable'.
	^ res
]

{ #category : #'as yet unclassified' }
GPAbstractCodeGeneratorConfiguration >> pickRandomMethod: methods with: w [
	|acc|
	acc:= 0.
	methods detect: [ :mw | 
		acc := acc + (mw weight).
		(acc >= w)  ].
	
]

{ #category : #'as yet unclassified' }
GPAbstractCodeGeneratorConfiguration >> pickRandomVariable: vars with: w [
"choose a variable according to weight system"
	|acc|
	acc:= 0.
	vars detect: [ :mw | 
		acc := acc + (mw weight).
		(acc >= w) ].
	
]

{ #category : #'as yet unclassified' }
GPAbstractCodeGeneratorConfiguration >> randomCalls [ 
"% according to Roassal3 methods "
	|c|
	c:= self randomElementOf: (0 to: 99).
	(c < 57) ifTrue: [ ^ 1 ]. " 0 calls, 57%"
	(c < 70) ifTrue: [ ^ 2 ]. "1 call, 13%"
	(c < 90) ifTrue: [ ^ 3 ]. "2 calls, 20%"
	(c < 95) ifTrue: [ ^ 4 ]. "3 calls, 5%"
	(c < 98) ifTrue: [ ^ 5 ]. "4 calls, 3%"
	^ 6 "5 calls, 2%"
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
	res := GPNodeGeneratorCode new.
	
	res printBlock: [ :children :context | '^ ' , (children first printUsing: context), ' '].
	res type: 'return'.
	res name: 'return'.
	^ res 
]

{ #category : #'as yet unclassified' }
GPAbstractCodeGeneratorConfiguration >> sumWeightsAllMethods [ 
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
GPAbstractCodeGeneratorConfiguration >> sumWeightsAllVariables [ 
	self subclassResponsibility 
]

{ #category : #accessing }
GPAbstractCodeGeneratorConfiguration >> variables [ 
	self subclassResponsibility 
]
