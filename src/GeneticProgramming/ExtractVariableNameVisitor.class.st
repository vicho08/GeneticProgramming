Class {
	#name : #ExtractVariableNameVisitor,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'variableNames',
		'classNames'
	],
	#category : #'GeneticProgramming-CodeGenerator'
}

{ #category : #accesing }
ExtractVariableNameVisitor >> allClasses [
	"return all classes in Pharo"

	^ Smalltalk allClasses asOrderedCollection
]

{ #category : #accesing }
ExtractVariableNameVisitor >> classNames [ 
	
	^ classNames removeDuplicates
]

{ #category : #initialization }
ExtractVariableNameVisitor >> initialize [ 
    super initialize.
    variableNames := OrderedCollection new.
	 classNames    := OrderedCollection new.
]

{ #category : #boolean }
ExtractVariableNameVisitor >> isClass: maybeClassSymbol [
"return true if the symbol is a Class"
	^ (self allClasses) includes: (OpalCompiler new source: maybeClassSymbol; evaluate)
]

{ #category : #accesing }
ExtractVariableNameVisitor >> variableNames [
    ^ variableNames removeDuplicates 
]

{ #category : #initialization }
ExtractVariableNameVisitor >> visitVariableNode: aVariableNode [
"Visit a variable node, and we need to know if it is a class or a variable"
	|node|
	node := aVariableNode name.
	(self isClass: node)
	ifTrue: [ classNames add: node]
	ifFalse:[ variableNames add: node].
   ^ aVariableNode
]
