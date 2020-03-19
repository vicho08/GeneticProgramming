Class {
	#name : #GPEngine,
	#superclass : #Object,
	#instVars : [
		'configuration',
		'population',
		'logs'
	],
	#category : #'GeneticProgramming-Core'
}

{ #category : #accessing }
GPEngine >> configuration [
	^ configuration
]

{ #category : #accessing }
GPEngine >> configuration: aGPConfiguration [
	configuration := aGPConfiguration
]

{ #category : #hooks }
GPEngine >> createInitialPopulation [
	population := (1 to: self populationSize)
		collect: [ :i | self createNewIndividual ]
]

{ #category : #evolution }
GPEngine >> createNewGeneration [
	"The argument is a collection of GPNode, each element being the root node of an individual."
	"check if problem solved"
	| i1 i2 newInd newPopulation |
	(self distanceFromSolutionOf: self pickBestIndividual) = 0 ifTrue: [ ^ self ].
	
	newPopulation := OrderedCollection new. 
	population size timesRepeat: [
		((configuration randomInt: 100) < 90) 
			ifTrue: [  
				i1 := self tournament.
				i2 := self tournament.
				newInd := i1 crossOverWith: i2 using: configuration random ]
			ifFalse: [ 
				newInd := self mutation ].
		newPopulation add: newInd
	].
	population := newPopulation
]

{ #category : #'as yet unclassified' }
GPEngine >> createNewGenerationOLD [
	"The argument is a collection of GPNode, each element being the root node of an individual."
	| fitIndividuals oldIndividual offSprings oldPopulation |
	fitIndividuals := self pickFitIndividuals.

	oldIndividual := population copyFrom: 1 to: (population size * 0.25) asInteger.
	"Mutation on the old individuals"
	1 to: (population size * 0.05) asInteger do: [ :unused |
		configuration mutate: (self randomElementOf: oldIndividual) 
	].

	offSprings := OrderedCollection new.
	(population size * 0.25) asInteger timesRepeat: [
		| i1 i2 |
		i1 := self randomElementOf: fitIndividuals.
		i2 := self randomElementOf: fitIndividuals.
		offSprings add: (i1 crossOverWith: i2 using: configuration random) 
	].
	oldPopulation := population.
	population := fitIndividuals , oldIndividual, offSprings.
	
"	Halt if: [ self numberOfDifferentIndividuals > 2 ].
	self numberOfDifferentIndividualsIn: fitIndividuals.
	self numberOfDifferentIndividualsIn: oldIndividual.
	self numberOfDifferentIndividualsIn: offSprings.
	
	self numberOfDifferentIndividualsIn: population.
	self numberOfDifferentIndividualsIn: oldPopulation."
]

{ #category : #operations }
GPEngine >> createNewIndividual [
	self assert: [ configuration notNil ] description: 'You must set a configuration'.
	^ configuration createNewIndividual

]

{ #category : #'as yet unclassified' }
GPEngine >> distanceFromSolutionOf: individual [
	^ configuration distanceFromSolutionOf: individual
]

{ #category : #hooks }
GPEngine >> execute [
	"
	| e| 
	e := self new.
	e configuration: GPAritConfiguration new.
	e execute.
	"
	 
	| log |
	self createInitialPopulation.
	1 to: configuration numberOfGenerations do: [ :gen | 
		self createNewGeneration.
		log := GPLog new.
		log generation: gen.
		log bestFitnessValue: self fitnessOfBestIndividual.
		log worstFitnessValue: self fitnessOfWorstIndividual.
		logs add: log. 

		self fitnessOfBestIndividual = 0
			ifTrue: [ ^ self ] ]
]

{ #category : #accessing }
GPEngine >> fitnessOfBestIndividual [
	^ self distanceFromSolutionOf: self pickBestIndividual
]

{ #category : #accessing }
GPEngine >> fitnessOfWorstIndividual [
	^ self distanceFromSolutionOf: self pickWorstIndividual
]

{ #category : #visualization }
GPEngine >> gtInspectorViewIn: composite [
	<gtInspectorPresentationOrder: -10>
	composite roassal2
		title: 'View';
		initializeView: [ self visualize ]
]

{ #category : #initialization }
GPEngine >> initialize [
	super initialize.
	logs := OrderedCollection new
]

{ #category : #evolution }
GPEngine >> mutation [
	"Return an element, picked randomly from the population, that has been mutated"
	| ind |
	ind := (self randomElementOf: population) deepCopy.
	configuration mutate: ind.
	^ ind
]

{ #category : #evolution }
GPEngine >> negativeTournamentIndex [
	"Return the index of the worst individual from a tournament"
	| fitness worst index |
	fitness := SmallInteger minVal.
	worst := nil.
	2 timesRepeat: [ 
		| competitor i |
		index := configuration randomInt: population size.
		competitor := population at: index.
		i := self distanceFromSolutionOf: competitor.
		i > fitness ifTrue: [ 
			worst := competitor.
			fitness := self distanceFromSolutionOf: competitor ]
	].
	^ index
]

{ #category : #'as yet unclassified' }
GPEngine >> numberOfDifferentIndividuals [
	^ self numberOfDifferentIndividualsIn: self population
]

{ #category : #'as yet unclassified' }
GPEngine >> numberOfDifferentIndividualsIn: setOfIndividuals [
	^ (setOfIndividuals collect: [ :i | i print ]) asSet size
]

{ #category : #'as yet unclassified' }
GPEngine >> pickBestIndividual [
	^ self rankedIndividuals first
]

{ #category : #'as yet unclassified' }
GPEngine >> pickFitIndividuals [
	"return the list of individuals that are considered as fit"
	^ self returnTopIndividuals: 0.5
]

{ #category : #'as yet unclassified' }
GPEngine >> pickWorstIndividual [
	^ self rankedIndividuals last
]

{ #category : #accessing }
GPEngine >> population [
	^ population 
]

{ #category : #accessing }
GPEngine >> populationSize [
	^ configuration populationSize
]

{ #category : #'private-random operations' }
GPEngine >> randomElementOf: aCollection [
	^ configuration randomElementOf: aCollection
]

{ #category : #'as yet unclassified' }
GPEngine >> rankedIndividuals [
	"return the list of individuals, sorted as the best match in front"
	| d as |
	d := Dictionary new.
	population do: [ :i | d at: i put: (self distanceFromSolutionOf: i) abs].
	as := (d associations asSortedCollection: [ :a1 :a2 | a1 value < a2 value ]).
	^ as collect: #key

]

{ #category : #'as yet unclassified' }
GPEngine >> ratioOfDifferentIndividualsIn: setOfIndividuals [
	^ ((self numberOfDifferentIndividualsIn: setOfIndividuals) / setOfIndividuals size) asFloat round: 2
]

{ #category : #'as yet unclassified' }
GPEngine >> returnTopIndividuals: ratio [
	"return the list of individuals that are considered as fit"
	^ self rankedIndividuals copyFrom: 1 to: (population size * ratio) asInteger

]

{ #category : #evolution }
GPEngine >> tournament [
	"Return the best individual from a tournament"
	| fitness best |
	fitness := SmallInteger maxVal.
	best := nil.
	5 timesRepeat: [ 
		| competitor i |
		competitor := configuration randomElementOf: population.
		i := self distanceFromSolutionOf: competitor.
		i < fitness ifTrue: [ 
			best := competitor.
			fitness := self distanceFromSolutionOf: competitor ]
	].
	^ best
]

{ #category : #visualization }
GPEngine >> visualize [

	| g d |
	g := RTGrapher new.
	d := RTData new.
	d connectColor: Color blue.
	d points: logs.
	d y: #bestFitnessValue.
	g add: d.
	
	d := RTData new.
	d connectColor: Color red.
	d points: logs.
	d y: #worstFitnessValue.
	g add: d.
	^ g
]
