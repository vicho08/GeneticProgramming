"
Configuration that produce an equation following 
	tree ::= E
	E ::= E x E | E + E | E - E |  number
	
"
Class {
	#name : #GPPoly2Configuration,
	#superclass : #GPAbstractArithmeticConfiguration,
	#category : #'GeneticProgramming-Polynom2'
}

{ #category : #operations }
GPPoly2Configuration >> distanceFromSolutionOf: individual [
	"This method has to return a number that describes how close the individual is to the solution.
	If this returns 0, then the individual is a perfect match
	"
	
	"
	| b1 b2|
	b1 := [ :x | 6*x + 36 ].
	b2 := [ :x | x*x + (2 * x) + 3 ].
	{ b1 value: 2 . b2 value: 2 }
	"
	| numbersToTry context result res |
	numbersToTry := #(2 3 4 5).
	context := Dictionary new.
	result := 0.
	numbersToTry do: [ :x |
		res := x*x + (2 * x) + 3.
		context at: #x put: x.
		result := result + ((individual evaluateUsing: context) - res) abs.
	].
	^ result "* 10 + (individual numberOfNodes - 10) abs"
]

{ #category : #example }
GPPoly2Configuration >> example [
	"
	self new example print
	"
	| e |
	e := GPEngine new.
	e configuration: GPPoly2Configuration new.
	e execute.
	^ e pickBestIndividual


]

{ #category : #hooks }
GPPoly2Configuration >> numberOfGenerations [
	^ 250
]
