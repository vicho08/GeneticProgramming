Class {
	#name : #GPNumberPuzzleConfiguration,
	#superclass : #GPAbstractArithmeticConfiguration,
	#category : #'GeneticProgramming-NumberPuzzle'
}

{ #category : #operations }
GPNumberPuzzleConfiguration >> createNewIndividual [
	"Return a new individual"
	"
	(self new createNewIndividual; createNewIndividual) print
	"
	| f1 f2 |
	f1 := self sumNode.
	f2 := self sumNode.
	f1 addChild: f2.
	f1 addChild: self newTerminal.
	f2 addChild: self newTerminal.
	f2 addChild: self newTerminal.
	^ f1
]

{ #category : #operations }
GPNumberPuzzleConfiguration >> distanceFromSolutionOf: individual [
	"This method has to return a number that describes how close the individual is to the solution.
	If this returns 0, then the individual is a perfect match
	"

	| r firstNumber result penalty1 penalty2 |
	r := individual evaluate. 	 
	firstNumber := r // 100.
	result := (((firstNumber * 100) + (firstNumber * 10) + firstNumber) - r) abs.
	
	"All the tree number should be the same"
	"penalty2 := (individual allLeaves asSet size - 1) ."
	penalty2 := (individual allLeaves size = 3 ifTrue: [ 0 ] ifFalse: [100 ]) .

	""

	(individual allLeaves allSatisfy: [ :n | (n type \\ 10) = firstNumber ])
		ifTrue: [ penalty1 := 0 ]
		ifFalse: [ penalty1 := 100 ].
	^ result + penalty1 + penalty2
]

{ #category : #example }
GPNumberPuzzleConfiguration >> example [
	"
	self new example print
	"
	| e |
	e := GPEngine new.
	e configuration: GPNumberPuzzleConfiguration new.
	e execute.
	^ e pickBestIndividual



]

{ #category : #operations }
GPNumberPuzzleConfiguration >> newTerminal [
	"This method has to return a new function"

	"Could be x or a number"
	
	| n1 n2 n3 |
	n1 := self randomElementOf: (1 to: 9).
	n2 := self randomElementOf: (1 to: 9).
	n3 := self randomElementOf: (1 to: 9).
	^ self number: (n1 * 100) + (n2 * 10) + n3
]
