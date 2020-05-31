Class {
	#name : #Game,
	#superclass : #Object,
	#instVars : [
		'status',
		'position',
		'escenary',
		'score'
	],
	#category : #'GeneticProgramming-MarioGame'
}

{ #category : #operations }
Game >> destroyEnemy [
	escenary at: (position x + 1) put: #_
]

{ #category : #operations }
Game >> enemyAhead [
	^ self enemyAhead: (position + (1 @ 0))
]

{ #category : #operations }
Game >> enemyAhead: aPosition [
	^ [(escenary at: aPosition x)= #E] on: Exception do: [ false ]
	
]

{ #category : #accessing }
Game >> escenary [
	^escenary
]

{ #category : #accessing }
Game >> escenary: aEscenary [
	|c|
	c:= aEscenary asOrderedCollection.
	escenary:= c collect: [ :each | each asSymbol ]
]

{ #category : #'as yet unclassified' }
Game >> gameCopy [
	|g|
	g:= Game new.
	g escenary: escenary; position: position; score: score; status: status.
	^g
]

{ #category : #initialize }
Game >> initialize [ 
	super initialize.
	self position: (1 @ 0).
	self status: 'running'.
	self score: 0 .
	self escenary: '___EO__E____O_$'.
]

{ #category : #testing }
Game >> isDead: aPosition [
	((self enemyAhead: aPosition) or: (self obstacleAhead: aPosition))
	ifTrue: [ self  status: 'dead']
]

{ #category : #testing }
Game >> isWinner [
	(position x >= escenary size)
		ifTrue: [ self status: 'winner' ] 
]

{ #category : #operations }
Game >> jump [
	self obstacleAhead
		ifTrue:  [self score: score +10].
	self position: (self position + (2 @ 0)).
	self isDead: position
	
]

{ #category : #operations }
Game >> moveLeft [
	self position: (position - (1 @ 0)).
	(self obstacleAhead or: self enemyAhead)
		ifTrue: [ self status: 'dead' ]
]

{ #category : #operations }
Game >> moveRight [
"advance one frame, if has a obstacle or enemy then game over"
	self position: (self position + (1 @ 0)).
	self isDead: self position
]

{ #category : #operations }
Game >> obstacleAhead [
	^ self obstacleAhead: (position + (1 @ 0))
]

{ #category : #operations }
Game >> obstacleAhead: aPosition [
	^ [(escenary at: (aPosition x)) = #O] on: Exception do: [ false ]
	
]

{ #category : #accessing }
Game >> position [
	^ position
]

{ #category : #accessing }
Game >> position: aPosition [
	position := aPosition
]

{ #category : #accessing }
Game >> score [
	^ score
]

{ #category : #accessing }
Game >> score: aScore [
	score:= aScore
]

{ #category : #operations }
Game >> shoot [
	self enemyAhead
		ifFalse: [ ^ self ].
	self destroyEnemy.
	self score: score + 50
]

{ #category : #accessing }
Game >> status [ 
	^ status
]

{ #category : #accessing }
Game >> status: aStatus [
	status := aStatus
	
	
	
]
