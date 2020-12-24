Class {
	#name : #GPNodeGeneratorCode,
	#superclass : #GPNode,
	#instVars : [
		'nodeType',
		'numArgs',
		'returnType',
		'argsType'
	],
	#category : #'GeneticProgramming-Core'
}

{ #category : #accessing }
GPNodeGeneratorCode >> argsType [
	^ argsType
]

{ #category : #accessing }
GPNodeGeneratorCode >> argsType: aCollection [
	argsType:= aCollection
]

{ #category : #'as yet unclassified' }
GPNodeGeneratorCode >> countCallMethods [
	|total|
	total:= 0.
	(self nodeType = 'method') ifTrue: [ total := total + 1 ].
	
	(self children) do: [ :child |
		total := total + child countCallMethods. ].
	
	^total
]

{ #category : #operations }
GPNodeGeneratorCode >> crossOverTwoChildrenWith: anotherNode using: random [

	"This method should be called with two root nodes"

	| index1 index2 child1 child2 |
	index1 := (random nextInteger: self numberOfNodes - 1) + 1.
	index2 := (random nextInteger: anotherNode numberOfNodes - 1) + 1.
	child1 := self crossOverWith: anotherNode at: index1 at: index2.
	[ self verifyVariable: child1 ] whileTrue: [ 
		index1 := (random nextInteger: self numberOfNodes - 1) + 1.
		index2 := (random nextInteger: anotherNode numberOfNodes - 1) + 1.
		child1 := self crossOverWith: anotherNode at: index1 at: index2 ].

	child2 := anotherNode crossOverWith: self at: index2 at: index1.
	[ self verifyVariable: child2 ] whileTrue: [ 
		index1 := (random nextInteger: self numberOfNodes - 1) + 1.
		index2 := (random nextInteger: anotherNode numberOfNodes - 1) + 1.
		child2 := anotherNode crossOverWith: self at: index2 at: index1 ].

	^ { child1 . child2 }
]

{ #category : #operations }
GPNodeGeneratorCode >> deepCopy [
	| c |
	c := GPNodeGeneratorCode new.
	c nodeType: nodeType; evaluationBlock: evaluationBlock; printBlock: printBlock; name: name.
	c numArgs:  numArgs; returnType: returnType.
	self children do: [ :child |
		c addChild: child deepCopy ].
	^ c
]

{ #category : #operations }
GPNodeGeneratorCode >> deepCopy: ind [
	| c |
	c := GPNodeGeneratorCode  new.
	c nodeType: (ind nodeType); evaluationBlock: (ind evaluationBlock); printBlock: (ind printBlock); name: (ind name).
	((ind nodeType) = 'method') ifTrue: [ c numArgs: (ind numArgs); returnType: (ind returnType)]
	ifFalse:[c numArgs: nil; returnType: nil].
	ind children do: [ :child |
		c addChild: child deepCopy ].
	^ c
]

{ #category : #accessing }
GPNodeGeneratorCode >> nodeType [
	^ nodeType

]

{ #category : #accessing }
GPNodeGeneratorCode >> nodeType: aString [ 
	"assigment, return or method call"
	nodeType:= aString

]

{ #category : #accessing }
GPNodeGeneratorCode >> numArgs [ 
	^ numArgs

]

{ #category : #accessing }
GPNodeGeneratorCode >> numArgs: num [
	numArgs:= num

]

{ #category : #accessing }
GPNodeGeneratorCode >> returnType [
	^ returnType
]

{ #category : #accessing }
GPNodeGeneratorCode >> returnType: aCollection [ 
	returnType:= aCollection
]

{ #category : #'as yet unclassified' }
GPNodeGeneratorCode >> verifyVariable: aIndividual [
	|child|
	child:= aIndividual children at: 1.
	^ ((aIndividual nodeType = 'assigment') and: (child print = 'self')) or: ((aIndividual nodeType = 'assigment') and:(child nodeType ~= 'variable'))
]
