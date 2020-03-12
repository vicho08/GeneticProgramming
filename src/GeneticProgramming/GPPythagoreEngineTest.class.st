Class {
	#name : #GPPythagoreEngineTest,
	#superclass : #GPAbstactEngineTest,
	#category : #'GeneticProgramming-Pythagore'
}

{ #category : #initialization }
GPPythagoreEngineTest >> configurationClass [
	^ GPPythagoreConfiguration
]

{ #category : #tests }
GPPythagoreEngineTest >> testSolution [

	| c i1 i2 i3 i4 i5 |
	c := configuration.
	i1 := c multNode children: { c newTerminalA . c newTerminalA }.
	i2 := c multNode children: { c newTerminalB . c newTerminalB }.
	i3 := c multNode children: { c newTerminalC . c newTerminalC }.
	i4 := c sumNode children: { i1 . i2 }.
	i5 := c subNode children: { i4 . i3 }.

	self assert: (engine distanceFromSolutionOf: i5) equals: 0
]
