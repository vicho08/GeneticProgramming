Class {
	#name : #GPPythagoreConfiguration,
	#superclass : #GPAbstractArithmeticConfiguration,
	#category : #'GeneticProgramming-Pythagore'
}

{ #category : #operations }
GPPythagoreConfiguration >> distanceFromSolutionOf: individual [
	"This method has to return a number that describes how close the individual is to the solution.
	If this returns 0, then the individual is a perfect match
	"
	| t result c r1 r2 |
	t := #(#(3 5 5.830951894845301) #(8 14 16.1245154965971) #(32 11 33.83784863137726) #(4 3 5) #(7 4 8.06225774829855) #(16 24 28.844410203711913) #(2 9 9.219544457292887)).
		
	result := 0.
	c := Dictionary new.
	t do: [ :tupple |
		c at: #a put: tupple first.
		c at: #b put: tupple second.
		c at: #c put: tupple third.
	
		result := result + (individual evaluateUsing: c) abs.
		(individual allLeaves collect: #print) asSet size = 3 ifFalse: [ result := result + 1000000 ].
		"(individual print substrings select: [ :s | #('+' '-' '*') includes: s ]) asSet size = 3 ifFalse: [ result := result + 1000000 ]."
		
		"(individual evaluateUsing: c) = 0 ifTrue: [ result := result + 100 ]."
		"c at: #a put: 1.
		c at: #b put: 1.
		c at: #c put: 1.
		r1 := (individual evaluateUsing: c).

		c at: #a put: 1.
		c at: #b put: 2.
		c at: #c put: 1.
		r2 := (individual evaluateUsing: c).
		r1 = r2 ifTrue: [ result := result + 1000000 ]"
	].
	^ result abs < 0.00001 
		ifTrue: [ 0.0 ]
		ifFalse: [ result abs ]

]

{ #category : #example }
GPPythagoreConfiguration >> example [
	"
	self new example print
	"
	| e |
	e := GPEngine new.
	e configuration: GPPythagoreConfiguration new.
	e execute.
	^ e pickBestIndividual


]

{ #category : #'instance creation' }
GPPythagoreConfiguration >> newTerminal [
	"This method has to return a new function"

	"Could be x or a number"
	| t |
	t := (self randomElementOf: (1 to: 3)).
	t = 1 ifTrue: [ ^ self newTerminalA ].
	t = 2 ifTrue: [ ^ self newTerminalB ].
	t = 3 ifTrue: [ ^ self newTerminalC ].

]

{ #category : #'instance creation' }
GPPythagoreConfiguration >> newTerminalA [
	^ self variable: 'a'
]

{ #category : #'instance creation' }
GPPythagoreConfiguration >> newTerminalB [
	^ self variable: 'b'
]

{ #category : #'instance creation' }
GPPythagoreConfiguration >> newTerminalC [
	^ self variable: 'c'
]

{ #category : #hooks }
GPPythagoreConfiguration >> numberOfGenerations [
	^ 20
]
