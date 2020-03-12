Class {
	#name : #GPArithConfiguration,
	#superclass : #GPAbstractArithmeticConfiguration,
	#category : #'GeneticProgramming-Arithmetic'
}

{ #category : #operations }
GPArithConfiguration >> distanceFromSolutionOf: individual [
	"This method has to return a number that describes how close the individual is to the solution.
	If this returns 0, then the individual is a perfect match
	"

	^ (individual evaluate - 1273) abs
]

{ #category : #example }
GPArithConfiguration >> example [
	"
	self new example print
	"
	| e |
	e := GPEngine new.
	e configuration: GPArithConfiguration new.
	e execute.
	^ e pickBestIndividual

"
population select: [ :i | (self distanceFromSolutionOf: i) = 9 ]
"
]

{ #category : #operations }
GPArithConfiguration >> newTerminal [
	| res t |
	t := self randomElementOf: #(1 2 3 4 5 6).
	res := GPNode new.
	res printBlock: [ :children :context | t asString ].
	res evaluationBlock: [ :children :context | t ].
	^ res
]
