Class {
	#name : #GPCodeGenerator,
	#superclass : #GPAbstractCodeGeneratorConfiguration,
	#instVars : [
		'variables',
		'methods',
		'dictionary',
		'test',
		'unaryMethods',
		'binaryMethods'
	],
	#category : #'GeneticProgramming-CodeGenerator'
}

{ #category : #accessing }
GPCodeGenerator >> binaryMethods [
	^ binaryMethods
]

{ #category : #accessing }
GPCodeGenerator >> binaryMethods: aNameMethods [
	binaryMethods := aNameMethods 
]

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
	|d eval penalty penalty2| 
	d := Dictionary new.
	d := self dictionary copy.
	
	eval := [ individual evaluateUsing: d ]
			on: Exception
			do: [ 'error' ].
			
	penalty:=0.
	"penalty error eval"
	eval = 'error' ifTrue: [ penalty:= 10000 ].
	
	penalty2 := individual numberOfNodes <= 15
		ifTrue: [ 0 ]
		ifFalse: [ 10000].

	"the fitness is the difference between associated value in the dictionary and the expected value"
	^ ((d at: self variableTest) - (self valueTest)) abs + penalty + penalty2 .
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
	self parserMethods: namesMethods.

]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> generateWithVariables: vars unaryMethods: unaryMethods binaryMethods: binaryMethods [
"save variables set and methos set"
	self variables: vars.
	self unaryMethods: unaryMethods.
	self binaryMethods: binaryMethods.

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

{ #category : #'as yet unclassified' }
GPCodeGenerator >> parserMethods: anArray [
	| d numArgs unary binary|
	d := Dictionary newFrom: anArray.
	unary:= OrderedCollection new.
	binary := OrderedCollection new.
		
	d doWithIndex: [ :dd :i |
		numArgs:= ((d values at: i) >> (d keys at: i)) argumentNames size.
		numArgs = 0 ifTrue: [unary add: (d keys at:i)]. 
		numArgs = 1 ifTrue: [binary add: (d keys at: i)]].
	
	self unaryMethods: unary.
	self binaryMethods: binary.
	
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

{ #category : #accessing }
GPCodeGenerator >> unaryMethods [
	^ unaryMethods
]

{ #category : #accessing }
GPCodeGenerator >> unaryMethods: aNameMethods [
	unaryMethods := aNameMethods 
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
