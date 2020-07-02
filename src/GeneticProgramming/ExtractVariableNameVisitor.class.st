Class {
	#name : #ExtractVariableNameVisitor,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'variableNames'
	],
	#category : #'GeneticProgramming-CodeGenerator'
}

{ #category : #initialization }
ExtractVariableNameVisitor >> initialize [ 
    super initialize.
    variableNames := OrderedCollection new.
]

{ #category : #initialization }
ExtractVariableNameVisitor >> variableNames [
    ^ variableNames
]

{ #category : #initialization }
ExtractVariableNameVisitor >> visitVariableNode: aVariableNode [
    variableNames add: aVariableNode name.
    ^ aVariableNode
]
