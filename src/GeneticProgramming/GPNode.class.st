Class {
	#name : #GPNode,
	#superclass : #Object,
	#instVars : [
		'children',
		'type',
		'evaluationBlock',
		'printBlock'
	],
	#category : #'GeneticProgramming-Core'
}

{ #category : #'instance creation' }
GPNode class >> children: someNodes [
	^ self new children: someNodes
]

{ #category : #accessing }
GPNode >> addChild: aNode [
	children add: aNode
]

{ #category : #accessing }
GPNode >> allLeaves [
	| c |
	c := OrderedCollection new.
	self allLeaves: c.
	^ c
]

{ #category : #accessing }
GPNode >> allLeaves: collection [
	"Private usage"
	children do: [ :c |
		c isLeaf 
			ifTrue: [ collection add: c ]
			ifFalse: [ c allLeaves: collection ] ]
]

{ #category : #accessing }
GPNode >> atIndex: anIndex [
	^ self withAllChildren at: anIndex
]

{ #category : #operations }
GPNode >> atIndex: index put: anotherNode [
	| i |
	index < 1 ifTrue: [ ^ self ].
	i := index.
	i := i - 1.
	self children doWithIndex: [ :child :ii |
		i = 1 ifTrue: [  self children at: ii put: anotherNode. ^ self ].
		child atIndex: i put: anotherNode.
		i := i - 1. ].
	
]

{ #category : #accessing }
GPNode >> children [
	^ children
]

{ #category : #accessing }
GPNode >> children: someNodes [
	children := someNodes
]

{ #category : #operations }
GPNode >> crossOverWith: anotherNode [
	"This method should be called with two root nodes"
	^ self crossOverWith: anotherNode at: (self numberOfNodes - 1) atRandom + 1 at: (anotherNode numberOfNodes - 1) atRandom + 1
]

{ #category : #operations }
GPNode >> crossOverWith: anotherNode at: index1 at: index2 [
	"Return an offspring"
	| copy |
	copy := self deepCopy.
	copy atIndex: index1 put: (anotherNode atIndex: index2) deepCopy.
	^ copy
]

{ #category : #operations }
GPNode >> crossOverWith: anotherNode using: random [
	"This method should be called with two root nodes"

	^ self
		crossOverWith: anotherNode
		at: (random nextInt: self numberOfNodes - 1) + 1
		at: (random nextInt: anotherNode numberOfNodes - 1) + 1
]

{ #category : #operations }
GPNode >> deepCopy [
	| c |
	c := GPNode new type: type; evaluationBlock: evaluationBlock; printBlock: printBlock.
	self children do: [ :child |
		c addChild: child deepCopy ].
	^ c
]

{ #category : #initialization }
GPNode >> evaluate [
	^ self evaluateUsing: nil
]

{ #category : #initialization }
GPNode >> evaluateUsing: context [
	^ evaluationBlock value: children value: context
]

{ #category : #accessing }
GPNode >> evaluationBlock [
	^ evaluationBlock
]

{ #category : #accessing }
GPNode >> evaluationBlock: aOneArgBlock [
	"Take the children as argument"
	evaluationBlock := aOneArgBlock
]

{ #category : #accessing }
GPNode >> first [
	^ children first
]

{ #category : #initialization }
GPNode >> initialize [
	super initialize.
	children := OrderedCollection new.
	printBlock := [ :c | 
		| t |
		t := c inject: '(' into: [ :sum :el | sum, el print ].
		t, ')' ]
]

{ #category : #testing }
GPNode >> isLeaf [
	^ children isEmpty
]

{ #category : #metrics }
GPNode >> numberOfNodes [
	^ self withAllChildren size
]

{ #category : #initialization }
GPNode >> print [
	^ self printUsing: nil
]

{ #category : #accessing }
GPNode >> printBlock [
	^ printBlock
]

{ #category : #accessing }
GPNode >> printBlock: anObject [
	printBlock := anObject
]

{ #category : #initialization }
GPNode >> printUsing: context [
	^ printBlock value: children value: context
]

{ #category : #accessing }
GPNode >> second [
	^ children second
]

{ #category : #accessing }
GPNode >> type [
	^ type
]

{ #category : #accessing }
GPNode >> type: aSymbol [
	type := aSymbol
]

{ #category : #accessing }
GPNode >> withAllChildren [
	| c |
	c := OrderedCollection new.
	c add: self.
	self withAllChildren: c.
	^ c
]

{ #category : #accessing }
GPNode >> withAllChildren: collection [
	"Private usage"
	children do: [ :c |
		collection add: c.
		c withAllChildren: collection ]
]
