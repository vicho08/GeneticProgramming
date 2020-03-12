Class {
	#name : #GPNodeTest,
	#superclass : #TestCase,
	#category : #'GeneticProgramming-Tests'
}

{ #category : #tests }
GPNodeTest >> testCrossOver [
	| i1 i2 offspring c |
	c := GPArithConfiguration new.
	"i1 = (5 + (4 * 3))"
	i1 := c sumNode children: { c number: 5 . (c multNode children: { c number: 4 . c number: 3 }) }.
	
	"i2 = (5 * (1 + (6 - 3)))"	
	i2 := c multNode children: { c number: 5 . (c sumNode children: { c number: 1 . (c subNode children: {c number: 6 . c number: 3}) } ) }.
	
	self assert: i1 evaluate equals: 17.
	self assert: i2 evaluate equals: 20.
	self assert: i1 print equals: '(5 + (4 * 3))'.
	self assert: i2 print equals: '(5 * (1 + (6 - 3)))'.
	self assert: i1 numberOfNodes equals: 5.
	self assert: i2 numberOfNodes equals: 7.

	self assert: (i1 atIndex: 4) print equals: '4'.
	self assert: (i1 atIndex: 3) print equals: '(4 * 3)'.
	self assert: (i2 atIndex: 3) print equals: '(1 + (6 - 3))'.
	self assert: (i2 atIndex: 2) print equals: '5'.

	offspring := i1 crossOverWith: i2 at: 4 at: 2.
	self assert: offspring print equals: '(5 + (5 * 3))'.
	self assert: i1 print equals: '(5 + (4 * 3))'.
	self assert: i2 print equals: '(5 * (1 + (6 - 3)))'.

]

{ #category : #tests }
GPNodeTest >> testCrossOver02 [
	| i1 i2 offspring c |
	c := GPArithConfiguration new.
	i1 := c subNode children: { c number: 5 . (c multNode children: { c number: 2 . c number: 3 }) }.
	i2 := c multNode children: { c number: 5 . (c sumNode children: { c number: 1 . (c multNode children: {c number: 5 . c number: 3}) } ) }.
	
	self assert: i1 print equals: '(5 - (2 * 3))'.
	self assert: i2 print equals: '(5 * (1 + (5 * 3)))'.
	
	offspring := i1 crossOverWith: i2.
	self assert: offspring print ~= i1 print.
	self assert: offspring print ~= i2 print.
]
