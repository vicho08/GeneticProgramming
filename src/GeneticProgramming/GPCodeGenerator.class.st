Class {
	#name : #GPCodeGenerator,
	#superclass : #GPAbstractCodeGeneratorConfiguration,
	#instVars : [
		'args',
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
		'packageTesting',
		'sumWeightsAllVariables',
		'totalTests',
		'spyCache'
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
	
	self assignWeigthsVars: variables. 
	sumWeightsAllVariables := (self acumulator: variables).
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> assignWeightTo: aMethod [
	| w wg|
	wg := WeightGenerator new.
	(weightGen = 'similarity')
	ifTrue: [ 
		w:= 1000 - (11* (wg compare: (aMethod name asString) with: (nameMethod asString))). 
		(w> 0) 
			ifTrue: [aMethod weight: w]
			ifFalse: [aMethod weight: 1]. ].
	(weightGen = 'default')
	ifTrue: [ aMethod weight: 1 ].
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> assignWeightToVar: aVar [
	| w wg|
	wg := WeightGenerator new.
	(weightGen = 'similarity')
	ifTrue: [ 
		w:= 1000 - (11* (wg compare: (aVar name asString) with: (nameMethod asString))). 
		(w> 0) 
			ifTrue: [aVar weight: w]
			ifFalse: [aVar weight: 1]. ].
	(weightGen = 'default')
	ifTrue: [ self weightByClass: aVar ].
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> assignWeights: arrayMethods [
	
	arrayMethods do: [ :method |
		self assignWeightTo: method .
		 ]

]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> assignWeigthsVars: vars [
	vars do: [ :var |
		(var name = #self) 
			ifTrue: [ var weight: 1000 ]
			ifFalse: [self assignWeightToVar: var ].
		 ].

]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> calculateTotalTests [
		|total classesTesting pa|
		total:=0.
		pa:= (RPackageOrganizer default packageNamed: (packageTesting name asString) ).
		classesTesting := pa classes asOrderedCollection .	
		classesTesting do: [ :class |
		|running|
		running:= class buildSuite run.
		total:= total + (running passed size)]. 
		^ total
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
GPCodeGenerator >> codeBefore: aCode codeAfter: anOtherCode onPackageNamed: aPackage onPackageTesting: aPackageTests [
	|visitor spy|
	"settings"
	self codeBefore: aCode.
	self codeAfter: anOtherCode.
	self packageTesting: aPackageTests.
	self mainPackage: aPackage.
	
	"setting fitness"
	totalTests := self calculateTotalTests.
	
	"setting methods and variables and weight system"
	visitor  := self createVisitor: aCode , ' ' , anOtherCode .
	spy := self createSpy.
	self variables: (visitor variableNames).
	self classes: (spy allClasses).
	
	self getMethods: (spy allMethods).
	sumWeightsAllVariables := 0.
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> createGPArgs: setArgs [
	^ self createGPArgs: setArgs class: (self nameClass ) w: 1000.
		
	
	
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> createGPArgs: setArgs class: aClass types: typeCollection [
	^ setArgs collect: [ :arg | 
		|var ts|
		ts := nil.
		(typeCollection includes: arg) ifTrue:[
		ts := (typeCollection at: arg)].
		(ts isNotNil) ifTrue: [ts:= (ts asOrderedCollection )].
		var := GPVariable new name: arg;  nameClass: aClass; types: ts.
		var.].

]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> createGPArgs: setArgs class: aClass w: w [
	^ setArgs collect: [ :arg | 
		|var|
		var := GPVariable new name: arg; weight: w; nameClass: aClass.
		self sumWeightsAllVariables:( (self sumWeightsAllVariables)+ w).
		var.].
	
	
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> createGPArgs: setArgs class: aClass w: w types: typeCollection [
	^ setArgs collect: [ :arg | 
		|var ts|
		ts := (typeCollection at: arg).
		(ts isNotNil) ifTrue: [ts:= (ts asOrderedCollection )].
		var := GPVariable new name: arg; weight: w; nameClass: aClass; types: ts.
		self sumWeightsAllVariables:( (self sumWeightsAllVariables)+ w).
		var.].

]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> createSpy [
	|classesTesting ts|
	(spyCache isNotNil) ifTrue: [ ^ spyCache ].
	classesTesting := packageTesting  classes asOrderedCollection .	
		 
	ts :=(Type profile: [ 
	classesTesting do: [ :class |
		|running|
		running:= class buildSuite run.]] onPackageNamed: mainPackage ). 
	spyCache:= ts.
	^ ts 
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> createSpy: aCode [ 

	^ (Type profile: [aCode] onPackageNamed: mainPackage ).
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> createTypeCollector: aClass [ 
"type collector of current class"		
	^ TypeCollector typeInstvarsOfClass: aClass
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
		(self setContractMethod ) , String cr,
		variablesMethod , String cr,
		"'Halt onCount: 1000.' , String cr, "
		codeBefore, String cr,
		(individual print),
		'. "<== adding line"', String cr,
		codeAfter.
	
	
	[SystemAnnouncer uniqueInstance 
		suspendAllWhileStoring: [ mainClass compile: codeToCompile ].				]
	on: Exception
	do: [ ^1000 ].	
	penalty := individual numberOfNodes <= 10
		ifTrue: [ 0 ]
		ifFalse: [ 1000].
		
	penalty := individual allLeaves size <= 4
		ifTrue: [ penalty + 0 ]
		ifFalse: [ penalty + 1000].
		
	penalty := individual countCallMethods  < 7
		ifTrue: [ penalty + 0 ]
		ifFalse: [ penalty + 10000].

	
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
	
	"the fitness is the difference between total tests and passed tests"
	individual fitnessCache: ((totalTests  - eval) abs) + penalty.
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
GPCodeGenerator >> getArgumentTypes: aMethod [
	|ans|
	ans := (aMethod argumentTypes).
	(ans size ~= 0) ifTrue:[ ^ ans first asOrderedCollection].
	^ ans asOrderedCollection 
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> getClass: aClass [

	^ OpalCompiler new source: (aClass className ); evaluate.
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> getCountArgument: aMethod class: aClass [ 
	|class|
	class:= OpalCompiler new source: aClass ; evaluate.
	^ (class >> aMethod) argumentNames size .

]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> getMethods: aSetMethods [
	|ms|
	ms := OrderedCollection new.
	ms:= aSetMethods collect: [ :m |
		   |method|
			method := GPMethod new.
			method name: (m selector).
			method realClass: (m classSpy className).
			method numArgs: (self getCountArgument: (method name) class: (method realClass)).
			(m hasBeenExecuted) ifTrue:[
				method args: (self getArgumentTypes: m).
				method result: (m returnType) asOrderedCollection].
			method
		 ].

		methods := ms.

]

{ #category : #initialization }
GPCodeGenerator >> initialize [
	super initialize.
	self restartRespondsVariables.
	SettersMethod initialize.
	self callSystemWeight: ({ 57 . 70 . 90 . 95 . 98}) asOrderedCollection .
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
GPCodeGenerator >> mainClass [
	^ mainClass
]

{ #category : #accessing }
GPCodeGenerator >> mainPackage [
	^ mainPackage 
]

{ #category : #accessing }
GPCodeGenerator >> mainPackage: aPackageString [
	mainPackage := aPackageString
]

{ #category : #accessing }
GPCodeGenerator >> methods [ 
	^methods
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> nameClass [ 
	^ mainClass
]

{ #category : #accessing }
GPCodeGenerator >> nameClass: aClass [
   |tmpClass vars t|
	mainClass := aClass.

	vars:=  aClass instVarNames.
	t := self typesBySpy: aClass.
	variables addAll: (self createGPArgs: vars class: aClass types: t).
	variables add: (GPVariable new  name: #self;  nameClass: aClass; types: (aClass asOrderedCollection)).
	
	tmpClass := aClass superclass.
	[ tmpClass = Object ] whileFalse: [
	t := self typesBySpy: tmpClass.
	
	variables addAll: (self createGPArgs: (tmpClass instVarNames) class: tmpClass types: t).
	  tmpClass := tmpClass superclass. ].

	methods:= methods select: [ :m | (m possibleSenders: variables) size ~= 0 ]. 
	
	
	
]

{ #category : #accessing }
GPCodeGenerator >> nameMethod [
	^ nameMethod
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
GPCodeGenerator >> setContractMethod [
	|ans msplit|
	
	msplit := nameMethod splitOn: ':'.
	(msplit size = 1) ifTrue: [^nameMethod].
	ans := ''.
	msplit doWithIndex: [ :key :i | (i < msplit size) ifTrue: [ans := ans , key,  ': ' , (args at: i) , ' 	'.] ].
	^ ans.
]

{ #category : #initialization }
GPCodeGenerator >> setInitialValues: arrayValues [
	|dict|
	dict:= Dictionary new.
	variables doWithIndex:  [ :k :ii| dict add: k -> (arrayValues at: ii ) ].
	self dictionary: dict.
]

{ #category : #accessing }
GPCodeGenerator >> setOfArgs [
	|gpargs|
   args:= (self nameClass >> (self nameMethod) asSymbol) argumentNames.
	gpargs := self createGPArgs: args.
	variables addAll: gpargs.
]

{ #category : #accessing }
GPCodeGenerator >> setOfVariables [
	variables addAll: (self nameClass >> (self nameMethod) asSymbol) argumentNames.
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

{ #category : #accessing }
GPCodeGenerator >> sumWeightsAllVariables [
	^sumWeightsAllVariables
]

{ #category : #accessing }
GPCodeGenerator >> sumWeightsAllVariables: aNumber [
	sumWeightsAllVariables:= aNumber
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> testing: aTestClass [
	testClass:= aTestClass 
]

{ #category : #accessing }
GPCodeGenerator >> totalTests [
	^ totalTests 
]

{ #category : #accessing }
GPCodeGenerator >> types [
	^types
]

{ #category : #accessing }
GPCodeGenerator >> types: aDictionary [
	types:= aDictionary 
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> typesBySpy: aClass [
	|vars cs vs ans ms|
	
	vars:= aClass instVarNames.
	cs := aClass name asSymbol.
	ms := (self createSpy) allMethods.
	vs := ms select: [ :m | ((m originalMethod) isReturnField) and: (cs = (m classSpy className))] .
	ans:= Dictionary new. 
	vs do: [ :m | 
		ans at: (m selector) put: m returnType ].
	
	^ans
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

{ #category : #'as yet unclassified' }
GPCodeGenerator >> verifyArgument: aIndividual [
	|c|
	c:= self randomElementOf: (0 to: 9).
	((args isEmpty) or: (c= 9)) ifTrue: [ ^ true ].
	
	
	^ aIndividual withAllChildren select: [ :node | (node nodeType = 'variable') and: (args includes: ((node print) asSymbol)) ] > 0
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> weightByClass: aVar [
	|w cClass|
	w := 500.
	cClass := mainClass.
	[aVar nameClass = cClass] whileFalse: [ 
		cClass := cClass superclass.
		w := w /2. ].
	
	aVar weight: w.
]

{ #category : #accessing }
GPCodeGenerator >> weightGen [
	^weightGen 
]
