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
	| f funTarget penalty |
	f := 0.
	funTarget := [ :x | x * x + (3 * x)- 6].
	"Comparation between target funtion & individual"
	-100 to: 100 do: [ :i | 
		|d|
		d := Dictionary newFrom: {#x -> i}.
		f := f + ((individual evaluateUsing: d) - (funTarget value: i)) abs.
		].
	"Penalty size of solution"
	penalty := (individual allLeaves size <= 5 ifTrue: [0] ifFalse: [1000]).
	^  f + penalty
]

{ #category : #example }
GPSymbolicRegressionConfiguration >> example [ 
	|e|
	e:= GPEngine new.
	e configuration: GPSymbolicRegressionConfiguration  new.
	e execute.
	^ { e pickBestIndividual . e visualize}
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
