Class {
	#name : #GPMarioGame,
	#superclass : #GPAbstractGameConfiguration,
	#instVars : [
		'status',
		'position',
		'escenary',
		'score'
	],
	#category : #'GeneticProgramming-MarioGame'
}

{ #category : #operations }
GPMarioGame >> destroyEnemy [
	escenary at: (position x + 1) put: #_
]

{ #category : #operations }
GPMarioGame >> distanceFromSolutionOf: individual [
	"This method has to return a number that describes how close the individual is to the solution.
	If this returns 0, then the individual is a perfect match
	"
	|n|
	n:=1.
	self position: (0 @ 0).
	self status: 'running'.
	self score: 0 .
	self escenary: 'E___EO____O_$'.
	[self status = 'running' and:  (n < 15)] whileTrue: [ 
		self play: individual.	 
		n:= n +1.].
	
	^ 120 - score 
]

{ #category : #operations }
GPMarioGame >> enemyAhead [
	^ self enemyAhead: (position + (1 @ 0))
]

{ #category : #operations }
GPMarioGame >> enemyAhead: aPosition [
	^ [(escenary at: aPosition x)= #E] on: Exception do: [ false ]
	
]

{ #category : #accessing }
GPMarioGame >> escenary [
	^ escenary 
]

{ #category : #accessing }
GPMarioGame >> escenary: aEscenary [
	|c|
	c:= aEscenary asOrderedCollection.
	escenary:= c collect: [ :each | each asSymbol ]
]

{ #category : #hooks }
GPMarioGame >> example [
	|e|
	e:= GPEngine new.
	e configuration: GPMarioGame  new.
	e execute.
	^  e pickBestIndividual 
]

{ #category : #initialize }
GPMarioGame >> initialize [ 
	super initialize
]

{ #category : #testing }
GPMarioGame >> isDead: aPosition [
	((self enemyAhead: aPosition) or: (self obstacleAhead: aPosition))
	ifTrue: [ self  status: 'dead']
]

{ #category : #testing }
GPMarioGame >> isWinner [
	(position x >= escenary size)
		ifTrue: [ self status: 'winner' ] 
]

{ #category : #operations }
GPMarioGame >> jump [
	self obstacleAhead
		ifTrue:  [self score: score +10].
	self position: (self position + (2 @ 0)).
	self isDead: position
	
]

{ #category : #operations }
GPMarioGame >> moveLeft [
	self position: (position - (1 @ 0)).
	(self obstacleAhead or: self enemyAhead)
		ifTrue: [ self status: 'dead' ]
]

{ #category : #operations }
GPMarioGame >> moveRight [
"advance one frame, if has a obstacle or enemy then game over"
	self position: (self position + (1 @ 0)).
	self isDead: self position
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
	t := self randomElementOf: {[self jump] . [self shoot] . [self moveRight] . [self moveLeft] . [self moveRight] . [self moveLeft]}.
	res := GPNode new.
	res printBlock: [ :children :context | t asString ].
	res evaluationBlock: [ :children :context | t value].
	res type: 'action'.
	^ res
]

{ #category : #'instance creation' }
GPMarioGame >> newTerminalBoolean [
	|res t|
	t := self randomElementOf: { [ self enemyAhead ] . [ self obstacleAhead  ] }.
	res := GPNode new.
	res printBlock: [ :children :context | t asString ].
	res evaluationBlock: [ :children :context | t value].
	res type: 'boolean action'.
	^ res
]

{ #category : #operations }
GPMarioGame >> obstacleAhead [
	^ self obstacleAhead: (position + (1 @ 0))
]

{ #category : #operations }
GPMarioGame >> obstacleAhead: aPosition [
	^ [(escenary at: (aPosition x)) = #O] on: Exception do: [ false ]
	
]

{ #category : #operations }
GPMarioGame >> play: individual [
	individual evaluate.
	self isWinner.
]

{ #category : #accessing }
GPMarioGame >> position [
	^ position
]

{ #category : #accessing }
GPMarioGame >> position: aPosition [
	position := aPosition
]

{ #category : #accessing }
GPMarioGame >> score [
	^ self score
]

{ #category : #accessing }
GPMarioGame >> score: aScore [
	score:= aScore
]

{ #category : #operations }
GPMarioGame >> shoot [
	self enemyAhead
		ifFalse: [ ^ self ].
	self destroyEnemy.
	self score: score + 50
]

{ #category : #accessing }
GPMarioGame >> status [ 
	^ status
]

{ #category : #accessing }
GPMarioGame >> status: aStatus [
	status := aStatus
	
	
	
]
