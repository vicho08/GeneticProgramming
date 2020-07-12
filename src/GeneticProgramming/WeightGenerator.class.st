Class {
	#name : #WeightGenerator,
	#superclass : #Object,
	#instVars : [
		'dictionary'
	],
	#category : #'GeneticProgramming-CodeGenerator'
}

{ #category : #'as yet unclassified' }
WeightGenerator >> getDefault [ 
	^dictionary at: #_default_
]

{ #category : #'as yet unclassified' }
WeightGenerator >> getWeigth: aMethod [ 
	^dictionary at: aMethod
]

{ #category : #accessing }
WeightGenerator >> initialWeights: anArray [
	dictionary:= Dictionary newFrom: anArray
]

{ #category : #'as yet unclassified' }
WeightGenerator >> initialiaze [
	super initialize. 
]

{ #category : #accessing }
WeightGenerator >> methods [
	^dictionary keys
]

{ #category : #'as yet unclassified' }
WeightGenerator >> searchWeight: aMethod [
	(self methods includes: aMethod)
	ifTrue: [ ^self getWeigth: aMethod  ]
	ifFalse: [ ^self getDefault ].
]
