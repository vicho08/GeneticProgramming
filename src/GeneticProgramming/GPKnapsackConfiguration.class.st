Class {
	#name : #GPKnapsackConfiguration,
	#superclass : #GPConfiguration,
	#category : #'GeneticProgramming-Knapsack'
}

{ #category : #operations }
GPKnapsackConfiguration >> distanceFromSolutionOf: individual [
	"This method has to return a number that describes how close the individual is to the solution.
	If this returns 0, then the individual is a perfect match
	"
	| l |
	l := individual allLeaves.
	(l collect: #type) asSet size < l size ifTrue: [ ^ 100000000 ].
	^ (individual evaluate - 82) abs + individual allLeaves size
]

{ #category : #example }
GPKnapsackConfiguration >> example [
	"
	self new example print
	"
	| e |
	e := GPEngine new.
	e configuration: GPKnapsackConfiguration new.
	e execute.
	^ e pickBestIndividual


]

{ #category : #hooks }
GPKnapsackConfiguration >> newFunction [
	"This method has to return a new function"

	| res |
	res := GPNode new.
	res printBlock: [ :children :context | 
		'(', (children first printUsing: context), ' + ', (children second printUsing: context), ')' ].
	res evaluationBlock: [ :children :context | 
		(children first evaluateUsing: context) + (children second evaluateUsing: context) ].
	^ res
]

{ #category : #'instance creation' }
GPKnapsackConfiguration >> newTerminal [
	"This method has to return a new function"
	
	| res t |
	t := self randomElementOf: #(5 8 10 23 27 31 37 41).
	res := GPNode new.
	res type: t.
	res printBlock: [ :children :context | res type asString ].
	res evaluationBlock: [ :children :context | res type ].
	^ res
]
