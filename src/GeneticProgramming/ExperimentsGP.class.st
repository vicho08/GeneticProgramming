Class {
	#name : #ExperimentsGP,
	#superclass : #Object,
	#category : #'GeneticProgramming-CodeGenerator'
}

{ #category : #accessing }
ExperimentsGP >> callsOfEachAnswer: methods [
	|calls|
	calls := methods collect: [ :m | 
		|info|
		info := OrderedCollection new.
		info add: ((m at: 1) name).
		info add: ((m at: 2 ) countCallMethods ).
		info].
	^ calls 
]

{ #category : #accessing }
ExperimentsGP >> callsOfEachMethod: methods [
	|calls|
	calls := OrderedCollection new.
	methods do: [ :m | 
	|info y|
	info := OrderedCollection new.
	info add: (m name).
	y:= m ast body statements first value.
	info add: (self countCalls: y).
	calls  add: info].
	^ calls
]

{ #category : #'as yet unclassified' }
ExperimentsGP >> countCalls: method [
	|tm|
	tm:= 0.
	(method class = RBMessageNode)
	ifTrue:[
		tm := 1.
		tm:= tm + (self countCalls: (method receiver) ).
		(method arguments) do: [:arg | tm:= tm + (self countCalls: arg). ].
		].
	^ tm
]

{ #category : #operators }
ExperimentsGP >> getMethods: aPackage in: aPackageTesting [
   |package methods rs|
	package := (RPackageOrganizer default packageNamed: aPackage). " Paquete para experimentos "
	methods := package methods. "select all methods "
	
	rs := methods select: [ :m |
		|sn|
   sn := (m ast children select: [ :n | n isKindOf: RBSequenceNode ]) first.
   sn children size = 1]. "Only methods with a one line of code"
	
	"delete abstract methods"
	methods := rs select: [ :m | (m  isAbstract) = false ].
	
	methods := self testingMethods: methods package: aPackage in: aPackageTesting.
	
	methods := methods select: [ :m | m blockNodes size = 0 ]. "methods wihout blocks"
	
	^ methods
	
]

{ #category : #accessing }
ExperimentsGP >> isSetter: aMethod [
    | body astCache variableName |
    (aMethod selector select: [ :c | c = $: ]) size = 1 ifFalse: [ ^ false ].

    astCache := aMethod ast.    
    variableName := astCache arguments first name.
    
    body := astCache body.
    body statements size = 1 ifFalse: [ ^ false ].
    body children first class == RBAssignmentNode ifFalse: [ ^ false ].
    ^ ((body children first variable name = aMethod selector allButLast)
        and: (body children first value class = RBArgumentNode ))
        and: ( body children first value name = variableName )
]

{ #category : #'as yet unclassified' }
ExperimentsGP >> simpleExperiment: aMethod fileName: aNameFile weightSystem: wg [
	|g originalSource e ind | 
	g:= GPCodeGenerator new codeBefore: '' codeAfter: '' onPackageNamed: 'Roassal3-Chart' onPackageTesting: 'Roassal3-Chart-Tests'.

	originalSource := aMethod getSourceFromFile.
	g nameMethod: (aMethod selector asString).
	g nameClass: (aMethod methodClass).
	g setOfVariables: ''.
	
	g addWeights: wg.

	e := GPEngineGeneratorCode new.
	e nameFile: aNameFile.
	e configuration: g.
	e execute.
	ind := e pickBestIndividual.
	g distanceFromSolutionOf: ind.
	(aMethod methodClass) compile: originalSource.
	^ ind
]

{ #category : #accessing }
ExperimentsGP >> sizeOfEachMethod: methods [
	|sizing|
	sizing := OrderedCollection new.
	methods do: [ :method | 
	|info|
	info := OrderedCollection new.
	info add: (method name).
	info add: (method) ast body sourceCode size.
	sizing add:info].
	^ sizing
]

{ #category : #operators }
ExperimentsGP >> testingMethods: methods in: packageTest [
	|d ds|
	d:= (Dep profile: [
	   |e pa classesTesting|
		e:=0.
		pa:= (RPackageOrganizer default packageNamed: 'Roassal3-Chart-Tests').
		classesTesting := pa classes asOrderedCollection .	
		classesTesting do: [ :class |
		|running|
		running:= class buildSuite run.
		e := e + (running passed size)]. e] onPackageNamed: 'Roassal3-Chart').

	ds := (d allExecutedMethods) collect: [ :m | m selector ].

 	^ methods select: [ :m | ds includes: (m selector) ].
]

{ #category : #operators }
ExperimentsGP >> testingMethods: methods package: aPackage in: packageTest [
	|d ds|
	d:= (Dep profile: [
	   |e pa classesTesting|
		e:=0.
		pa:= (RPackageOrganizer default packageNamed: packageTest).
		classesTesting := pa classes asOrderedCollection .	
		classesTesting do: [ :class |
		|running|
		(class class canUnderstand: #buildSuite) ifTrue: [ 
		running:= class buildSuite run.
		e := e + (running passed size)]. e]] onPackageNamed: aPackage ).

	ds := (d allExecutedMethods) collect: [ :m | m selector ].

 	^ methods select: [ :m | ds includes: (m selector) ].
]

{ #category : #accessing }
ExperimentsGP >> totalAccessors: methods [
	|a|
	a := 0.
	methods do: [ :array | 
	( (array at: 1) isReturnField)
	ifTrue: [ a := a + 1. ]].
	^ a
]

{ #category : #accessing }
ExperimentsGP >> totalAccessorsCorrects: methods [
	|a|
	a := 0.
	methods do: [ :array | 
		(((array at: 3) = 0) and: (array at: 1) isReturnField)
		ifTrue: [ a := a + 1. ]].
	^ a 
]

{ #category : #accessing }
ExperimentsGP >> totalCorrects: methods [
   |a|
	a := 0.
 	methods  do: [ :array | 
	((array at: 3) = 0)
	ifTrue: [ a := a + 1. ]].
	^ a
]

{ #category : #accessing }
ExperimentsGP >> totalSetters: methods [
   |a|
	a := 0.
	methods do: [ :array | 
	( (array at: 1) isSetter)
	ifTrue: [ a := a + 1. ]].
	^ a
]

{ #category : #accessing }
ExperimentsGP >> totalSettersCorrects: methods [
   |a|
	a := 0.
	methods do: [ :array | 
	(((array at: 3) = 0) and: (array at: 1) isSetter)
	ifTrue: [ a := a + 1. ]].
	^ a
]

{ #category : #accessing }
ExperimentsGP >> totalTime: ans [
	|time|
	time := 0 asDuration.
	ans do: [ :array | 
		((array at:4)seconds  > 0) ifTrue: [time:= time + (array at:4). ]].
	^ time
]
