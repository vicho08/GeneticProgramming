Class {
	#name : #GPConfiguration,
	#superclass : #Object,
	#instVars : [
		'random'
	],
	#category : #'GeneticProgramming-Core'
}

{ #category : #operations }
GPConfiguration >> createNewIndividual [
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
	rootNode := self newFunction.
	self createNewIndividualRoot: rootNode depth: 3.
	^ rootNode
]

{ #category : #'private-operation' }
GPConfiguration >> createNewIndividualRoot: rootNode depth: depth [
	depth = 1 ifTrue: [ 
		1 to: 2 do: [ :i |
			rootNode addChild: self newTerminal ]. 
		^ self ].
	
	"50% to change a terminal"
	1 to: 2 do: [ :i |
		self randomBoolean
			ifTrue: [ 
				| f |
				f := self newFunction.
				rootNode addChild: f.
				self createNewIndividualRoot: f depth: depth - 1 ]
			ifFalse: [ rootNode addChild: self newTerminal ] ]
]

{ #category : #operations }
GPConfiguration >> distanceFromSolutionOf: individual [
	"This method has to return a number that describes how close the individual is to the solution.
	If this returns 0, then the individual is a perfect match
	"
	self subclassResponsibility 
]

{ #category : #initialization }
GPConfiguration >> initialize [
	super initialize.
	random := Random seed: 42
]

{ #category : #operations }
GPConfiguration >> mutate: individual [
	self subclassResponsibility 
]

{ #category : #hooks }
GPConfiguration >> newFunction [
	"This method has to return a new function"
	self subclassResponsibility 
]

{ #category : #hooks }
GPConfiguration >> newTerminal [
	"This method has to return a new function"
	self subclassResponsibility 
]

{ #category : #hooks }
GPConfiguration >> numberOfGenerations [
	^ 20
]

{ #category : #accessing }
GPConfiguration >> populationSize [
	^ 40
]

{ #category : #accessing }
GPConfiguration >> random [
	^ random
]

{ #category : #'private-random operations' }
GPConfiguration >> randomBoolean [
	^ (random nextInt: 100) > 50
]

{ #category : #'private-random operations' }
GPConfiguration >> randomElementOf: aCollection [

	^ aCollection at: (random nextInteger: aCollection size)
]

{ #category : #'private-random operations' }
GPConfiguration >> randomInt: anInt [
	^ random nextInt: anInt
]
