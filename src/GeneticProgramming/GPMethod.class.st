Class {
	#name : #GPMethod,
	#superclass : #Object,
	#instVars : [
		'name',
		'numArgs',
		'weight',
		'sendersCache'
	],
	#category : #'GeneticProgramming-CodeGenerator'
}

{ #category : #'as yet unclassified' }
GPMethod >> implementorsClasses [
   |im|
	im := ((self name) implementors).
	^ im collect: [ :i | i methodClass ]
]

{ #category : #initialization }
GPMethod >> initialize [ 
	super initialize .
	sendersCache := nil.
]

{ #category : #accessing }
GPMethod >> name [ 
	^ name
]

{ #category : #accessing }
GPMethod >> name: aNameMethod [
	name:= aNameMethod
]

{ #category : #accessing }
GPMethod >> numArgs [
	^ numArgs
]

{ #category : #accessing }
GPMethod >> numArgs: aNumber [
	numArgs := aNumber
]

{ #category : #initialization }
GPMethod >> possibleSenders: variablesCollection [
	|im|
	im := self implementorsClasses .
	(sendersCache notNil) ifTrue: [ ^ sendersCache  ].
	sendersCache := (variablesCollection) select: [ :v | ((v types) intersection: im) size ~= 0 ] .
	^ sendersCache 
]

{ #category : #accessing }
GPMethod >> sendersCache [
	^ sendersCache
]

{ #category : #accessing }
GPMethod >> sendersCache: aCollection [ 
	sendersCache:= aCollection 
]

{ #category : #accessing }
GPMethod >> weight [ 
	^ weight
]

{ #category : #accessing }
GPMethod >> weight: aNumber [
	weight:= aNumber 
]
