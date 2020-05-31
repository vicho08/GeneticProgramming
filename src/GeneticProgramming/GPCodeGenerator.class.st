Class {
	#name : #GPCodeGenerator,
	#superclass : #GPAbstractCodeGeneratorConfiguration,
	#instVars : [
		'variables',
		'methods',
		'dictionary',
		'test'
	],
	#category : #'GeneticProgramming-CodeGenerator'
}

{ #category : #accessing }
GPCodeGenerator >> dictionary [
	^dictionary
]

{ #category : #accessing }
GPCodeGenerator >> dictionary: aDictionary [
	dictionary:= aDictionary 
]

{ #category : #operations }
GPCodeGenerator >> distanceFromSolutionOf: individual [
	"This method has to return a number that describes how close the individual is to the solution.
	If this returns 0, then the individual is a perfect match
	"
	|d| 
	d := Dictionary new.
	d := dictionary copy.
	individual evaluateUsing: d.
	
	"the fitness is the difference between associated value in the dictionary and the expected value"
	^ ((d at: self variableTest) - (self valueTest)) abs  
]

{ #category : #example }
GPCodeGenerator >> example [
	"
	self new example print
	"
	| e |
	e := GPEngine new.
	e configuration: self.
	e execute.
	^ e pickBestIndividual
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> generateWithVariables: vars andMessageNames: namesMethods [
"save variables set and methos set"
	self variables: vars.
	self methods: namesMethods .

]

{ #category : #initialization }
GPCodeGenerator >> initialize [
	super initialize.
]

{ #category : #accessing }
GPCodeGenerator >> methods [
	^methods

]

{ #category : #accessing }
GPCodeGenerator >> methods: aNameMethods [
	methods := aNameMethods 
]

{ #category : #initialization }
GPCodeGenerator >> setInitialValues: arrayValues [
	|dict|
	dict:= Dictionary new.
	variables doWithIndex:  [ :k :ii| dict add: k -> (arrayValues at: ii ) ].
	self dictionary: dict.
]

{ #category : #initialization }
GPCodeGenerator >> setTest: aKey value: n [
"
Set the test for fitness. Like: 'assert aKey equals: n'
"
	self test: { aKey . n }.
]

{ #category : #initialization }
GPCodeGenerator >> test: aKeyValue [
	test:= aKeyValue.
]

{ #category : #initialization }
GPCodeGenerator >> valueTest [
"Value for testing"
	^ test at: 2. 
]

{ #category : #initialization }
GPCodeGenerator >> variableTest [
"variable for testing"
	^ test at: 1. 
]

{ #category : #accessing }
GPCodeGenerator >> variables [
"varaibles set"
	^variables
]

{ #category : #accessing }
GPCodeGenerator >> variables: aVariables [
	variables := aVariables
]
