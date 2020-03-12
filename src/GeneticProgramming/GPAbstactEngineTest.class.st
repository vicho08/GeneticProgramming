Class {
	#name : #GPAbstactEngineTest,
	#superclass : #TestCase,
	#instVars : [
		'engine',
		'configuration'
	],
	#category : #'GeneticProgramming-Tests'
}

{ #category : #testing }
GPAbstactEngineTest class >> isAbstract [
	^ self name == #GPAbstactEngineTest

]

{ #category : #initialization }
GPAbstactEngineTest >> configurationClass [
	self subclassResponsibility
]

{ #category : #initialization }
GPAbstactEngineTest >> setUp [
	configuration := self configurationClass new.
	engine := GPEngine new.
	engine configuration: configuration
]

{ #category : #tests }
GPAbstactEngineTest >> testAllLeaves [
	| i |
	20 timesRepeat: [ 
		i := configuration createNewIndividual.
		self deny: i isLeaf.
		self assert: (i allLeaves allSatisfy: #isLeaf) ].

]

{ #category : #tests }
GPAbstactEngineTest >> testBasic [

	| best1 score1 best2 score2 |
	engine createInitialPopulation.
	best1 := engine pickBestIndividual.
	score1 := engine distanceFromSolutionOf: best1.
	10 timesRepeat: [ engine createNewGeneration ].
	best2 := engine pickBestIndividual.
	score2 := engine distanceFromSolutionOf: best2.
	self assert: score1 > score2.

]

{ #category : #tests }
GPAbstactEngineTest >> testBasic02 [

	| i1 i2 |
	i1 := engine createNewIndividual.
	i2 := engine createNewIndividual.
	(i1 print ~= i2 print) ifTrue: [ self assert: (engine distanceFromSolutionOf: i1) ~= (engine distanceFromSolutionOf: i2) ]
	 
]

{ #category : #tests }
GPAbstactEngineTest >> testIsLeaf [	
	20 timesRepeat: [ 
		self deny: configuration createNewIndividual isLeaf ].
	20 timesRepeat: [ 
		self assert: configuration newTerminal isLeaf ].
]

{ #category : #tests }
GPAbstactEngineTest >> testMutation [
	| i1 i2 |
	engine createInitialPopulation.
	i1 := engine mutation.
	self assert: i1 class == GPNode.
	i2 := engine mutation.
	self assert: i2 class == GPNode.
	self assert: i1 print ~= i2 print
]

{ #category : #tests }
GPAbstactEngineTest >> testTournament [
	| i1 i2 |
	engine createInitialPopulation.
	i1 := engine tournament.
	self assert: i1 class == GPNode.
	i2 := engine tournament.
	self assert: i2 class == GPNode.
	self assert: i1 print ~= i2 print
]
