Class {
	#name : #GPCodeGenerator,
	#superclass : #GPAbstractCodeGeneratorConfiguration,
	#instVars : [
		'args',
		'variables',
		'classes',
		'typesSpyCache',
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

{ #category : #adding }
GPCodeGenerator >> addSelf [ 
	variables add: (GPVariable new  name: #self;  nameClass: mainClass ; types: (mainClass asOrderedCollection)).
]

{ #category : #adding }
GPCodeGenerator >> addVariables: aClass [
	(aClass instVarNames) ifNil: [ ^ self ].
	variables addAll: (self createGPArgs: (aClass instVarNames) class: aClass types: (self typesBySpy: aClass)).
]

{ #category : #adding }
GPCodeGenerator >> addWeights: aWeightGenerator [
	weightGen := aWeightGenerator.
	
	self assignWeights: methods.
	self assignWeigthsVars: variables. 
	
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> assignWeightTo: aElement [
	|w|
	(weightGen = 'similarity')
	ifTrue: [ w:= self weightBySimilarity: aElement ].
	(weightGen = 'naive')
	ifTrue: [ w:= 1000 ].
	(weightGen = 'uniform')
	ifTrue: [ w:= 1 ].
	(weightGen = 'hierarchy')
	ifTrue: [ w:= self weightByClass: aElement].
	(weightGen = 'balanced')
	ifTrue: [ w:= ((self weightByClass: aElement) + (self weightBySimilarity: aElement )) *0.5].
	
	aElement weight: w.
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> assignWeightToVar: aVar [
	|w|
	(weightGen = 'similarity')
	ifTrue: [ w:= self weightBySimilarity: aVar ].
	(weightGen = 'naive')
	ifTrue: [ w:= 1000 ].
	(weightGen = 'uniform')
	ifTrue: [ w:= self weightByClass: aVar ].
	(weightGen = 'hierarchy')
	ifTrue: [ w:= self weightByClass: aVar].
	(weightGen = 'balanced')
	ifTrue: [ w:= ((self weightByClass: aVar) + (self weightBySimilarity: aVar )) *0.5].
	
	aVar weight: w.
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> assignWeights: arrayMethods [
	|sum|
	sumWeightsAllMethods := 0.
	sum :=0.
	arrayMethods do: [ :method |
		self assignWeightTo: method .
		sum := sum + (method weight).
		 ].
	sumWeightsAllMethods := sum.
	

]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> assignWeigthsVars: vars [
	|sum|
	sum :=0.
	sumWeightsAllVariables :=0.
	vars do: [ :var |
		(var name = #self) 
			ifTrue: [ var weight: 1000 ]
			ifFalse: [self assignWeightToVar: var ].
		sum := sum + (var weight).
		 ].
	sumWeightsAllVariables := sum.

]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> calculateTotalTests [
		|total|
		total:=0.
			
		(packageTesting classesTesting ) do: [ :class |
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
GPCodeGenerator >> codeToCompile: ind [
"Return the source code of any individual"
	^	(self setContractMethod ) , String cr,
		variablesMethod , String cr,
		codeBefore, String cr,
		(ind print),
		'. "<== adding line"', String cr,
		codeAfter.

]

{ #category : #compiling }
GPCodeGenerator >> compileCode: sourceCode [
	[SystemAnnouncer uniqueInstance 
		suspendAllWhileStoring: [ mainClass compile: sourceCode].]
	on: Exception
	do: [ ^1000 ].

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
		(typeCollection keys includes: arg) ifTrue:[
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
	|ts|
	(spyCache isNotNil) ifTrue: [ ^ spyCache ].
	
		 
	ts :=(Type profile: [ 
	(packageTesting classesTesting ) do: [ :class |
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
	|codeToCompile eval penalty|
	
	individual fitnessCache ifNotNil: [ ^ individual fitnessCache ].
	codeToCompile := self codeToCompile: individual.		
	self tryToCompileCode: codeToCompile . 
		
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
	
	
	(packageTesting classesTesting )  do: [ :class |
		|running p|
		p := [ class buildSuite run.] newProcess.
		p resume.
		(Delay forSeconds: 0.7) wait.
			p isTerminated 
			ifTrue: [
				running:= class buildSuite run.
				eval := eval + (running passed size)]
			ifFalse: [ 
				"self inform: 'Not terminated'. "
				penalty := penalty + 10000.
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
	(aMethod arguments isNotNil and: (aMethod result isNotNil))ifTrue:[
	ans := (aMethod argumentTypes).
	(ans size ~= 0) ifTrue:[ ^ ans first asOrderedCollection].
	^ ans asOrderedCollection ].
	^ nil
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
				m result ifNotNil:[
				|ts|
				ts:= [(m returnType).]
					on: Exception
					do: [ nil].	
				method result: ts asOrderedCollection]].
			method
		 ].

		methods := ms.

]

{ #category : #initialization }
GPCodeGenerator >> initialize [
	super initialize.
	self restartRespondsVariables.
	SettersMethod initialize.
	typesSpyCache := Dictionary new. 
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
   |tmpClass|
	mainClass := aClass.
	
	self addSelf.
	self addVariables: aClass.
	
	
	tmpClass := aClass superclass.
	[ tmpClass = Object ] whileFalse: [
		self addVariables: tmpClass. 
		tmpClass := tmpClass superclass. ].

	methods:= methods select: [ :m | (m possibleSenders: variables) size ~= 0 ]. 
	
	
	
]

{ #category : #accessing }
GPCodeGenerator >> nameMethod [
	^ nameMethod
]

{ #category : #accessing }
GPCodeGenerator >> nameMethod: aNameMethod [
	nameMethod := aNameMethod.
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> nameMethod: aNameMethod in: aClass [
	self nameMethod: aNameMethod.
	self nameClass: aClass.
	self removeMainMethod.
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
	packageTesting:= GPPackage new name: aString.
]

{ #category : #removing }
GPCodeGenerator >> removeMainMethod [
	methods := methods select: [ :m | (mainClass name ~= m realClass) or: (m name ~= nameMethod asSymbol) ]
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

{ #category : #compiling }
GPCodeGenerator >> tryToCompileCode: sourceCode [
"try to compile source code, if not return a high value fitness"
	[SystemAnnouncer uniqueInstance 
		suspendAllWhileStoring: [ mainClass compile: sourceCode].]
	on: Exception
	do: [ ^10000 ].

]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> typesBySpy: aClass [
	|vars cs vs ans ms|
	"types of intance variables"
	(typesSpyCache includes: aClass) ifTrue: [ ^ typesSpyCache at: aClass ].
	
	vars:= aClass instVarNames.
	cs := aClass name asSymbol.
	ms := (self createSpy) allMethods.
	vs := ms select: [ :m | ((m originalMethod) isReturnField) and: (cs = (m classSpy className))] .
	ans:= Dictionary new. 
	vs do: [ :m | 
		|t|
		t:= m result.
		t ifNil: [ans at: (m selector) put: nil]
		ifNotNil: [ ans at: (m selector) put: ((m result asOrderedCollection) addAll: (m returnType ) asOrderedCollection; yourself) ]].
	typesSpyCache at: aClass put: ans.
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

{ #category : #accessing }
GPCodeGenerator >> verifyArgument: aIndividual [

	| c |
	c := self randomElementOf: (0 to: 9).
	args ifNil: [ ^ true ].
	(args isEmpty or: c = 9) ifTrue: [ ^ true ].


	^ (aIndividual withAllChildren select: [ :node | 
		  node nodeType = 'variable' and:
			  (args includes: node print asSymbol) ]) size = (args size)
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> weightByClass: aElement [
	|w cClass|
	w := 500.
	cClass := mainClass.
	[(aElement getClassGP = cClass name) or: (cClass = Object)] whileFalse: [ 
		cClass := cClass superclass.
		w := w /2. ].
	(cClass = Object) ifTrue: [ ^ 1. ] ifFalse: [ ^ w ]
	
]

{ #category : #'as yet unclassified' }
GPCodeGenerator >> weightBySimilarity: aElement [
	|w wg|
	wg:= WeightGenerator new.
	w:= 1000 - (11* (wg compare: (aElement name asString) with: (nameMethod asString))). 
		(w> 0) 
			ifTrue: [^ w]
			ifFalse: [^ 1].
]

{ #category : #accessing }
GPCodeGenerator >> weightGen [
	^weightGen 
]
