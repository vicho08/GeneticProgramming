Class {
	#name : #GPCELConfiguration,
	#superclass : #GPAbstractArithmeticConfiguration,
	#category : #'GeneticProgramming-ChiffresEtLettres'
}

{ #category : #operations }
GPCELConfiguration >> distanceFromSolutionOf: individual [
	"This method has to return a number that describes how close the individual is to the solution.
	If this returns 0, then the individual is a perfect match
	"
	| l |
	l := individual allLeaves.
	^ (individual evaluate - 595) abs + ((l size - (l collect: #type) asSet size) * 3)

"	| l |
	l := individual allLeaves.
	(l collect: #type) asSet size < l size ifTrue: [ ^ 10000 ].
	^ (individual evaluate - 459) abs"
]

{ #category : #example }
GPCELConfiguration >> example [
	"
	self new example print
	"
	| e |
	e := GPEngine new.
	e configuration: GPCELConfiguration new.
	e execute.
	^ e pickBestIndividual


]

{ #category : #'instance creation' }
GPCELConfiguration >> newTerminal [
	"This method has to return a new function"

	"Could be x or a number"
	^ self number: (self randomElementOf: #(10 1 25 9 3 6))
	"25 7 8 100 4 2"
]

{ #category : #accessing }
GPCELConfiguration >> populationSize [
	^ 2000
]
