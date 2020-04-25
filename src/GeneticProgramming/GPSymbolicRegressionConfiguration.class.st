Class {
	#name : #GPSymbolicRegressionConfiguration,
	#superclass : #GPAbstractArithmeticConfiguration,
	#category : #'GeneticProgramming-SymbolicRegression'
}

{ #category : #operations }
GPSymbolicRegressionConfiguration >> distanceFromSolutionOf: individual [
	"This method has to return a number that describes how close the individual is to the solution.
	If this returns 0, then the individual is a perfect match
	"

	| f funTarget penalty eval |
	f := 0.
	funTarget := [ :x | x * x * 0.5].
	"Comparation between target funtion & individual"
	-100 to: 100 do: [ :i | 
		| d |
		d := Dictionary newFrom: {(#x -> i)}.
		eval := [ individual evaluateUsing: d ]
			on: Exception
			do: [ 'div by zero' ].
		"Function that divide by zero is punished"
		f := eval == 'div by zero'
			ifTrue: [ f + 1000]
			ifFalse: [ f + (eval - (funTarget value: i)) abs ] ].
	"Penalty size of solution"
	penalty := individual allLeaves size <= 4
		ifTrue: [ 0 ]
		ifFalse: [ 1000].
	^ f + penalty
]

{ #category : #example }
GPSymbolicRegressionConfiguration >> example [ 
	|e|
	e:= GPEngine new.
	e configuration: GPSymbolicRegressionConfiguration  new.
	e execute.
	^  e pickBestIndividual
]

{ #category : #operations }
GPSymbolicRegressionConfiguration >> newFunction [
	"This method has to return a new function"

	| c |
	c := (self randomElementOf: (1 to: 4)).
	c = 1 ifTrue: [ ^ self sumNode ].
	c = 2 ifTrue: [ ^ self multNode ].
	c = 3 ifTrue: [ ^ self subNode ].
	c = 4 ifTrue: [ ^ self divNode ].

	
	
]

{ #category : #operations }
GPSymbolicRegressionConfiguration >> newTerminalNumber [
	| res t a|
	a := Array newFrom: (-10 to: 10).
	t := self randomElementOf: a.
	
	res := GPNode new.
	res printBlock: [ :children :context | t asString ].
	res evaluationBlock: [ :children :context | t ].
	^ res

	
	
]

{ #category : #hooks }
GPSymbolicRegressionConfiguration >> numberOfGenerations [
	^ 30
]
