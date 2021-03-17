Class {
	#name : #GPcodeGeneratorGP,
	#superclass : #TestCase,
	#instVars : [
		'g'
	],
	#category : #'GeneticProgramming-CodeGenerato-Tests'
}

{ #category : #initialize }
GPcodeGeneratorGP >> setUp [
	g:= GPCodeGenerator new codeBefore: '' codeAfter: '' onPackageNamed: 'Roassal3-Chart' onPackageTesting: 'Roassal3-Chart-Tests'.
	g nameMethod: 'maxValueX';  nameClass: RSAbstractPlot; setOfVariables: ''.
	
	g setOfArgs .

	g addWeights: 'similarity'.
	

]

{ #category : #tests }
GPcodeGeneratorGP >> testAssigment [
	|i| 

	100 timesRepeat: [
	i:= g assigmentNode .
	g createNewIndividualRoot: i depth: 3.
	self assert: ((i children at: 1) print) ~= 'self'.]
]

{ #category : #tests }
GPcodeGeneratorGP >> testReturn [

	| i |
	100 timesRepeat: [ 
		i := g returnNode.
		g createNewIndividualRoot: i depth: 3.
		self assert: (i print asString at: 1) identicalTo: $^.
		self assert: (i print asString at: 2) identicalTo: Character space.
		self assert: (i print asString at: 3) ~= $^. ]
]
