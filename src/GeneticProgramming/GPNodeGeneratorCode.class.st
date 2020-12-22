Class {
	#name : #GPNodeGeneratorCode,
	#superclass : #GPNode,
	#instVars : [
		'nodeType',
		'numArgs'
	],
	#category : #'GeneticProgramming-Core'
}

{ #category : #'as yet unclassified' }
GPNodeGeneratorCode >> countCallMethods [
	|total|
	total:= 0.
	(self type isNumber) ifTrue: [ total := total + 1 ].
	
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

	^ { 
		  child1.
		  child2 }
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

{ #category : #'as yet unclassified' }
GPNodeGeneratorCode >> verifyVariable: aIndividual [
	|child|
	child:= aIndividual children at: 1.
	^ ((aIndividual type = 'assigment') and: (child print = 'self')) or: ((aIndividual type = 'assigment') and:(child type ~= 'variable'))
]