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
	types:= aCollection
]

{ #category : #accessing }
GPVariable >> weight [
	^ weight
]

{ #category : #accessing }
GPVariable >> weight: aNumber [
	weight:= aNumber
]
