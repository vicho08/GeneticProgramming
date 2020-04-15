Class {
	#name : #GPSymbolicRegressionTest,
	#superclass : #GPAbstactEngineTest,
	#category : #'GeneticProgramming-SymbolicRegression'
}

{ #category : #initialization }
GPSymbolicRegressionTest >> configurationClass [
	^ GPArithConfiguration
]

{ #category : #tests }
GPSymbolicRegressionTest >> testFitness [
	|c i|
	c := GPSymbolicRegressionConfiguration new.
	"(0.5 * (x * x))"
	i := c multNode children: { c number: 0.5 . (c multNode children: {c variable: 'x' . c variable: 'x'}) }.
	self assert: (c distanceFromSolutionOf: i ) equals: 0.
	self assert: i print equals: '(0.5 * (x * x))'.
]
