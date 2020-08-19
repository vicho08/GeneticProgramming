Class {
	#name : #GPCodeGenerator,
	#superclass : #GPAbstractCodeGeneratorConfiguration,
	#instVars : [
		'variables',
		'classes',
		'types',
		'codeBefore',
		'codeAfter',
		'respondsVariables',
		'weightGen',
		'methods',
		'sumWeightsAllMethods'
	],
	#category : #'GeneticProgramming-CodeGenerator'
}

{ #category : #'as yet unclassified' }
GPCodeGenerator >> acumulator: ms [
	|sum|
	sum := 0.
	ms do: [ :m | sum := sum + (m weight)].
	^ sum
]

{ #category : #adding }
GPCodeGenerator >> addWeights: aWeightGenerator [
	weightGen := aWeightGenerator.
	
	self assignWeights: methods.
	sumWeightsAllMethods := (self acumulator: methods).
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> assignWeightTo: aMethod [
	| w |
	w:= (self weightGen) searchWeight: aMethod name.
	aMethod weight: w.
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> assignWeights: arrayMethods [
	
	arrayMethods do: [ :method |
		self assignWeightTo: method .
		 ]

]

{ #category : #accessing }
GPCodeGenerator >> classes [
	^classes
]

{ #category : #accessing }
GPCodeGenerator >> classes: aNameClasses [
	classes:= aNameClasses
]

{ #category : #accessing }
GPCodeGenerator >> codeAfter [ 
	^codeAfter 
]

{ #category : #accessing }
GPCodeGenerator >> codeAfter: aCode [
	codeAfter := aCode
]

{ #category : #accessing }
GPCodeGenerator >> codeBefore [
	^codeBefore
]

{ #category : #accessing }
GPCodeGenerator >> codeBefore: aCode [
	codeBefore := aCode
]

{ #category : #initialization }
GPCodeGenerator >> codeBefore: aCode codeAfter: anOtherCode [
	|visitor|
	
	self codeBefore: aCode.
	self codeAfter: anOtherCode.
	
	visitor  := self createVisitor: aCode , ' ' , anOtherCode .
	
	self variables: (visitor variableNames).
	self classes: (visitor classNames).
	
	self getMethods: classes.
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> createVisitor: aCode [ 

	|ast v|
	ast := RBParser parseExpression: aCode.
	v := ExtractVariableNameVisitor new.
	ast acceptVisitor: v.
	^ v
]

{ #category : #operations }
GPCodeGenerator >> distanceFromSolutionOf: individual [
	"This method has to return a number that describes how close the individual is to the solution.
	If this returns 0, then the individual is a perfect match
	"
	|codeToCompile eval "penalty penalty2"|
	individual fitnessCache ifNotNil: [ ^ individual fitnessCache ].
	codeToCompile :=
		'setUp', String cr,
		'|x y d q|', String cr,
		codeBefore, String cr,
		(individual print),
		'. "<== adding line"', String cr,
		codeAfter.
	
	[SystemAnnouncer uniqueInstance 
		suspendAllWhileStoring: [ CodeGeneratorTest compile: codeToCompile ].				]
	on: Exception
	do: [ ^100 ].	
	
	eval := CodeGeneratorTest buildSuite run passed size.	
	"penalty:=0."
	"penalty error eval"
	"eval = 'error' ifTrue: [ penalty:= 10000 ].
	
	penalty2 := individual numberOfNodes <= 15
		ifTrue: [ 0 ]
		ifFalse: [ 10000]."

	"the fitness is the difference between associated value in the dictionary and the expected value"
	individual fitnessCache: (4 - eval) abs.
	^ individual fitnessCache
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
GPCodeGenerator >> extractVariableNames: code [
	|ast v|
	ast := RBParser parseExpression: code.
	v := ExtractVariableNameVisitor new.
	ast acceptVisitor: v.
	^ v variableNames.
	
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

{ #category : #'as yet unclassified' }
GPCodeGenerator >> getClass: aSymbolClass [
	^ OpalCompiler new source: aSymbolClass; evaluate.
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> getClasses: aCollection [
	|answer|
	answer := OrderedCollection new.
	aCollection 
			do: [ :aClass| 
			(self isClass: aClass) ifTrue: [ answer add: aClass ] ].
	^ answer removeDuplicates
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> getMethods: aClasses [
	|ms|
	ms := OrderedCollection new.
	aClasses do: [ :c |
		|aClass|
		aClass := self getClass: c.
		(aClass selectors) do: [ :m|
			|method|
			method := GPMethod new.
			method name: m.
			method numArgs: (aClass >> m) argumentNames size .
			ms add: method.
		 ].].

		methods := ms.

]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> getVariables: aCollection [
|answer|
	answer:= OrderedCollection new.
	aCollection 
		do: [ :aVariable | 
			(self isClass: aVariable)
				ifFalse: [ answer add: aVariable ] ].
	^ answer removeDuplicates
]

{ #category : #initialization }
GPCodeGenerator >> initialize [
	super initialize.
	self restartRespondsVariables.
]

{ #category : #testing }
GPCodeGenerator >> isClass: aSymbol [
	^Smalltalk allClassesAndTraits
				includes:
					(OpalCompiler new
						source: aSymbol;
						evaluate)
]

{ #category : #testing }
GPCodeGenerator >> isKeywordMethod: aMethod Class: aClass [
	^(aClass >> aMethod) argumentNames size = 1

]

{ #category : #testing }
GPCodeGenerator >> isUnaryMethod: aMethod Class: aClass [
	^(aClass >> aMethod) argumentNames size = 0

]

{ #category : #hooks }
GPCodeGenerator >> numberOfGenerations [
	^ 30
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

{ #category : #'as yet unclassified' }
GPCodeGenerator >> respondsVariables [
	^ respondsVariables
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> restartRespondsVariables [
	respondsVariables:= OrderedCollection new.
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

{ #category : #accessing }
GPCodeGenerator >> types [
	^types
]

{ #category : #accessing }
GPCodeGenerator >> types: aDictionary [
	types:= aDictionary 
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

{ #category : #accessing }
GPCodeGenerator >> weightGen [
	^weightGen 
]
