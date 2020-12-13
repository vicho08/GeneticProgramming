Class {
	#name : #GPEngineGeneratorCode,
	#superclass : #GPEngine,
	#category : #'GeneticProgramming-Core'
}

{ #category : #evolution }
GPEngineGeneratorCode >> createNewGeneration [
	"The argument is a collection of GPNode, each element being the root node of an individual."
	"check if problem solved"
	| newInd newInd2 newInds newPopulation sizeHalf n_calls|
	(self distanceFromSolutionOf: self pickBestIndividual) = 0 ifTrue: [ ^ self ].
	
	newPopulation := OrderedCollection new. 
	newPopulation add: self pickBestIndividual.
	sizeHalf := ((population size -1) / 2.0) ceiling.
	sizeHalf timesRepeat: [
		newInds := self repeatOperatorsGenetics.
		newInd := newInds at: 1.
		newInd2 := newInds at: 2.
		n_calls:= self randomCalls.
		[(self verifyCallsMethods: ({newInd . newInd2} asOrderedCollection) value: n_calls)]
	 whileFalse: [ 
		newInds:= self repeatOperatorsGenetics. 
		newInd := newInds at:1.
		newInd2 := newInds at: 2.].
		newPopulation add: newInd.
		newPopulation add: newInd2.  
	].
	population := newPopulation.
	fitnessOfPopulation := self totalFitnessOfGeneration 
]

{ #category : #'as yet unclassified' }
GPEngineGeneratorCode >> randomCalls [ 
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
GPEngineGeneratorCode >> repeatOperatorsGenetics [
 	|i1 i2 newInds|
		i1 := self  tournament .
		i2 := self tournament .
		newInds := i1 crossOverTwoChildrenWith: i2 using: configuration random.
		((configuration randomInt: 100) > 85)
			ifTrue: [ self mutation: (newInds at: 1) ].
		((configuration randomInt: 100) > 85)
			ifTrue: [ self mutation: (newInds at: 2) ].
		^ newInds
]

{ #category : #'as yet unclassified' }
GPEngineGeneratorCode >> verifyCallMethod: individual value: val [
	^ individual countCallMethods <= val
]

{ #category : #'as yet unclassified' }
GPEngineGeneratorCode >> verifyCallsMethods: individuals value: val [
	^ (self verifyCallMethod: (individuals at: 1) value: val) and: (self verifyCallMethod: (individuals at: 2) value: val) 
]
