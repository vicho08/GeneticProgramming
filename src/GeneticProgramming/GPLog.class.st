Class {
	#name : #GPLog,
	#superclass : #Object,
	#instVars : [
		'bestFitnessValue',
		'averageFitness',
		'generation',
		'worstFitnessValue'
	],
	#category : #'GeneticProgramming-Core'
}

{ #category : #accessing }
GPLog >> averageFitness [
	^ averageFitness
]

{ #category : #accessing }
GPLog >> averageFitness: aNumber [
	averageFitness := aNumber
]

{ #category : #accessing }
GPLog >> bestFitnessValue [
	^ bestFitnessValue
]

{ #category : #accessing }
GPLog >> bestFitnessValue: aNumber [
	bestFitnessValue := aNumber
]

{ #category : #accessing }
GPLog >> generation [
	^ generation
]

{ #category : #accessing }
GPLog >> generation: aNumber [
	generation := aNumber
]

{ #category : #accessing }
GPLog >> worstFitnessValue [
	^ worstFitnessValue
]

{ #category : #accessing }
GPLog >> worstFitnessValue: aNumber [
	worstFitnessValue := aNumber
]
