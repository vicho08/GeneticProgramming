Class {
	#name : #GPMethod,
	#superclass : #Object,
	#instVars : [
		'name',
		'numArgs',
		'weight'
	],
	#category : #'GeneticProgramming-CodeGenerator'
}

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
GPMethod >> weight [ 
	^ weight
]

{ #category : #accessing }
GPMethod >> weight: aNumber [
	weight:= aNumber 
]
