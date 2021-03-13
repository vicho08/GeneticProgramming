Class {
	#name : #GPMethod,
	#superclass : #Object,
	#instVars : [
		'name',
		'numArgs',
		'weight',
		'args',
		'result',
		'realClass',
		'sendersCache'
	],
	#category : #'GeneticProgramming-CodeGenerator'
}

{ #category : #accessing }
GPMethod >> args [
	^ args
]

{ #category : #accessing }
GPMethod >> args: aCollection [ 
	args:= aCollection 
]

{ #category : #'as yet unclassified' }
GPMethod >> implementorsClasses [
   |im|
	im := ((self name) implementors).
	^ im collect: [ :i | i methodClass ]
]

{ #category : #initialization }
GPMethod >> initialize [ 
	super initialize .

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

{ #category : #accessing }
GPMethod >> possibleSenders: variables [

	sendersCache notNil ifTrue: [ ^ sendersCache ].
	sendersCache := variables select: [ :v | 
		                v types
			                ifNil: [ true ]
			                ifNotNil: [ v types includes: realClass ] ].
	^ sendersCache
]

{ #category : #'as yet unclassified' }
GPMethod >> realClass [
	^ realClass
]

{ #category : #'as yet unclassified' }
GPMethod >> realClass: aClass [
	realClass:= aClass
]

{ #category : #accessing }
GPMethod >> result [
	^ result
]

{ #category : #accessing }
GPMethod >> result: types [ 
	result:= types
]

{ #category : #accessing }
GPMethod >> weight [ 
	^ weight
]

{ #category : #accessing }
GPMethod >> weight: aNumber [
	weight:= aNumber 
]
