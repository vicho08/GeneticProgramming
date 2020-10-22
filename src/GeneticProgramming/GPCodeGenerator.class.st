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
		'sumWeightsAllMethods',
		'mainPackage',
		'mainClass',
		'nameMethod',
		'variablesMethod',
		'testClass',
		'packageTesting'
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
	
	|visitor spy|
	
	self codeBefore: aCode.
	self codeAfter: anOtherCode.
	
	visitor  := self createVisitor: aCode , ' ' , anOtherCode .
	spy      := self createSpy: aCode, ' ' , anOtherCode .
	
	self variables: (visitor variableNames).
	self classes: (spy allClasses).
	
	self getMethods: classes.
]

{ #category : #initialization }
GPCodeGenerator >> codeBefore: aCode codeAfter: anOtherCode onPackageNamed: aPackage [
	|visitor spy|
	
	self codeBefore: aCode.
	self codeAfter: anOtherCode.
	mainPackage := aPackage.
	
	visitor  := self createVisitor: aCode , ' ' , anOtherCode .
	spy := self createSpy: aCode , ' ' , anOtherCode.
	self variables: (visitor variableNames).
	variables add: #self.
	self classes: (spy allClassesAsDictionary).
	
	self getMethods: classes.
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> createSpy: aCode [ 

	^ (Dep profile: [aCode] onPackageNamed: mainPackage ).
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
	|codeToCompile eval penalty classesTesting|
	individual fitnessCache ifNotNil: [ ^ individual fitnessCache ].
	codeToCompile :=
		nameMethod , String cr,
		variablesMethod , String cr,
		"'Halt onCount: 1000.' , String cr, "
		codeBefore, String cr,
		(individual print),
		'. "<== adding line"', String cr,
		codeAfter.
	
	(codeToCompile  findString: 'self ', nameMethod) >0 
	ifTrue:[^1000].
	
	[SystemAnnouncer uniqueInstance 
		suspendAllWhileStoring: [ mainClass compile: codeToCompile ].				]
	on: Exception
	do: [ ^100 ].	
	penalty := individual numberOfNodes <= 15
		ifTrue: [ 0 ]
		ifFalse: [ 1000].

	
	eval := 0.
	classesTesting := packageTesting classes.
	
	"classesTesting do: [ :class |
		[|running|
		running:= class buildSuite run.
		eval := eval + (running passed size) ] on: Halt do: [^1000]]."

	classesTesting do: [ :class |
		|running p|
		p := [ class buildSuite run.] newProcess.
		p resume.
		(Delay forSeconds: 0.5) wait.
			p isTerminated 
			ifTrue: [
				running:= class buildSuite run.
				eval := eval + (running passed size)]
			ifFalse: [ 
				self inform: 'Not terminated'. 
    			p terminate ]].
	
	"the fitness is the difference between associated value in the dictionary and the expected value"
	individual fitnessCache: ((59 - eval) abs) + penalty.
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
GPCodeGenerator >> getClass: aClass [

	^ OpalCompiler new source: (aClass className ); evaluate.
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

{ #category : #accessing }
GPCodeGenerator >> methods [ 
	^methods
]

{ #category : #accessing }
GPCodeGenerator >> nameClass: aClass [
	mainClass := aClass.
	variables addAll: (aClass instVarNames)
]

{ #category : #accessing }
GPCodeGenerator >> nameMethod: aNameMethod [
	nameMethod := aNameMethod
]

{ #category : #hooks }
GPCodeGenerator >> numberOfGenerations [
	^ 30
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> packageTesting [
	^ packageTesting
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> packageTesting: aString [
	packageTesting:= (RPackageOrganizer default packageNamed: aString).
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

{ #category : #accessing }
GPCodeGenerator >> setOfVariables: aSetOfVariables [
	variablesMethod := aSetOfVariables 
]

{ #category : #initialization }
GPCodeGenerator >> setTest: aKey value: n [
"
Set the test for fitness. Like: 'assert aKey equals: n'
"
	self test: { aKey . n }.
]

{ #category : #accessing }
GPCodeGenerator >> sumWeightsAllMethods [
	^sumWeightsAllMethods 
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> testing: aTestClass [
	testClass:= aTestClass 
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
