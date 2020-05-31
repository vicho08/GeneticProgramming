Class {
	#name : #GPMarioGame,
	#superclass : #GPAbstractGameConfiguration,
	#category : #'GeneticProgramming-MarioGame'
}

{ #category : #accessing }
GPMarioGame class >> escenary [
	^ escenary 
]

{ #category : #operations }
GPMarioGame >> distanceFromSolutionOf: individual [
	"This method has to return a number that describes how close the individual is to the solution.
	If this returns 0, then the individual is a perfect match
	"
	|n game|
	n:=1.
	game := Game new.
	[game status = 'running' and:  (n < 15)] whileTrue: [ 
		self play: individual game: game.	 
		n:= n +1.].
	
	^ 120- (game score)
]

{ #category : #hooks }
GPMarioGame >> example [
	|e|
	e:= GPEngine new.
	e configuration: GPMarioGame  new.
	e execute.
	^ e pickBestIndividual
]

{ #category : #'as yet unclassified' }
GPMarioGame >> games: aIndividual [
	|c n game current|
	game:= Game new.
	c:= OrderedCollection new.
	current := game gameCopy.
	c add: current.
	n := 0.
	current:= game.
	[game status = 'running' and:  (n < 15)] whileTrue: [ 
		self play: aIndividual game: game.
		current:= game gameCopy.
		c add: current.	 
		n:= n +1.].
	^c
]

{ #category : #initialize }
GPMarioGame >> initialize [ 
	super initialize.
]

{ #category : #hooks }
GPMarioGame >> newFunction [
	"This method has to return a new function"
	self conditionalNode  
]

{ #category : #hooks }
GPMarioGame >> newNodeBoolean: depth [
	"This method has to return a new function"
	|t node|
	self randomBoolean | (depth = 1)
		ifTrue: [ ^ self newTerminalBoolean ]
		ifFalse: [ 
			t:= self randomElementOf: { self andNode .  self orNode }.
			node := t value. 
			1 to: 2 do: [:i |
				node addChild: (self newNodeBoolean: depth-1)].
			^ node ].
]

{ #category : #hooks }
GPMarioGame >> newTerminal [
	"This method has to return a new function"
	
	self newTerminalAction  
]

{ #category : #hooks }
GPMarioGame >> newTerminalAction [
	| res t |
	t := self randomElementOf: {#jump. #shoot. #moveRight . #moveLeft . #moveRight . #moveLeft}.
	res := GPNode new.
	res printBlock: [ :children :context | t asString ].
	res evaluationBlock: [ :children :context | (context at: #game)  perform: t ]  .
	res type: 'action'.
	^ res
]

{ #category : #'instance creation' }
GPMarioGame >> newTerminalBoolean [
	|res t|
	t := self randomElementOf: { #enemyAhead . #obstacleAhead }.
	res := GPNode new.
	res printBlock: [ :children :context | t asString ].
	res evaluationBlock: [ :children :context | (context at: #game) perform: t].
	res type: 'boolean action'.
	^ res
]

{ #category : #operations }
GPMarioGame >> play: individual game: game [
	|g|
	g:= Dictionary newFrom: {(#game -> game)}.
	individual evaluateUsing: g.
	game isWinner.
]
