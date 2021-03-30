Class {
	#name : #GPVariable,
	#superclass : #Object,
	#instVars : [
		'name',
		'weight',
		'nameClass',
		'types'
	],
	#category : #'GeneticProgramming-CodeGenerator'
}

{ #category : #'as yet unclassified' }
GPVariable >> getClassGP [ 
	^ nameClass name
]

{ #category : #accessing }
GPVariable >> name [
	^name
]

{ #category : #accessing }
GPVariable >> name: aName [
	name:= aName
]

{ #category : #accessing }
GPVariable >> nameClass [
	^ nameClass 
]

{ #category : #accessing }
GPVariable >> nameClass: aName [
	nameClass := aName
]

{ #category : #accessing }
GPVariable >> types [ 
	^ types
]

{ #category : #accessing }
GPVariable >> types: aCollection [

	"possible types of a variable by TypeCollector"

	types := aCollection isNotNil
		         ifTrue: [ aCollection collect: [ :v | v ] ]
		         ifFalse: [ nil ]
]

{ #category : #accessing }
GPVariable >> weight [
	^ weight
]

{ #category : #accessing }
GPVariable >> weight: aNumber [
	weight:= aNumber
]

{ #category : #'as yet unclassified' }
GPVariable >> weightByUniform: configuration [
	^ configuration weightByClass: self
]
