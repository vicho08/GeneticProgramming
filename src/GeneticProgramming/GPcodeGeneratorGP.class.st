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
	g:= GPCodeGenerator new codeBefore: '' codeAfter: '' onPackageNamed: 'Roassal3-Chart'.
	g nameMethod: 'maxValueX'; nameClass: RSAbstractPlot; setOfVariables: ''.
	
	g setOfArgs .
	g packageTesting: 'Roassal3-Chart-Tests'.

	g addWeights: (WeightGenerator new initialWeights: {#max -> 1700. #definedValuesX -> 1700 . #_default_ -> 1}).
	

]

{ #category : #tests }
GPcodeGeneratorGP >> testAssigment [
	|i| 

	100 timesRepeat: [
	i:= g assigmentNode .
	g createNewIndividualRoot: i depth: 3.
	self assert: ((i children at: 1) print) ~= 'self'.]
]
