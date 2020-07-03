Class {
	#name : #GPNode,
	#superclass : #Object,
	#instVars : [
		'children',
		'type',
		'evaluationBlock',
		'printBlock',
		'name',
		'fitnessCache'
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
	|i changeNode|
	index =1 ifTrue: [ ^ anotherNode ].
	i:= index.
	changeNode:= self atIndex: index.
	[ i > 0 ] whileTrue: [
		i := i - 1.
		(self atIndex: i) children doWithIndex:[ :child :ii |
			child = changeNode
			ifTrue: [ (self atIndex: i) children at: ii put: anotherNode. ^ self]
	]]
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

	| index1 index2 node otherNode |
	index1:= (random nextInt: self numberOfNodes - 1) + 1.
	index2:= (random nextInt: anotherNode numberOfNodes - 1) + 1.
	self haveType & anotherNode haveType
		ifTrue: [ 
			node := self atIndex: index1.
			otherNode := anotherNode atIndex: index2.
			[ node sameType: otherNode ]
				whileFalse: [ 
					index1:= (random nextInt: self numberOfNodes - 1) + 1.
					node := self atIndex: index1.
					index2 := (random nextInt: anotherNode numberOfNodes - 1) + 1.
					otherNode := anotherNode atIndex: index2]].
		^ self crossOverWith: anotherNode at: index1 at: index2 
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

{ #category : #accessing }
GPNode >> fitnessCache [
	^ fitnessCache
]

{ #category : #accessing }
GPNode >> fitnessCache: aNumber [
	"Cache the fitness value. Does not copy the fitness when doing a deepcopy"
	fitnessCache := aNumber
]

{ #category : #'gt-inspector-extension' }
GPNode >> gtInspectorTableIn: composite [
	<gtInspectorPresentationOrder: -15>
	composite text
		title: 'Print';
		display: [ self print ]
]

{ #category : #testing }
GPNode >> haveType [
	^ self type isNotNil.
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

{ #category : #accessing }
GPNode >> name [
	^ name
]

{ #category : #accessing }
GPNode >> name: aSymbol [
	name := aSymbol
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

{ #category : #testing }
GPNode >> sameType: anotherNode [
	^ self type = anotherNode type
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
