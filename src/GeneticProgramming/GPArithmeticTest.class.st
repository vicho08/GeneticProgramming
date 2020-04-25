Class {
	#name : #GPArithmeticTest,
	#superclass : #TestCase,
	#category : #'GeneticProgramming-Tests'
}

{ #category : #tests }
GPArithmeticTest >> testConditionalNode [
	| i1  i2 c |
	c := GPArithConfiguration new.
	"i1 = (if true then 1 else 0"
	i1 := c conditionalNode  children: { c boolean: true . c number: 1 . c number: 0}.
	
	i2:= c conditionalNode children: { c boolean: false . c number: 1 . c number: 0 }.
	
	
	self assert: i1 evaluate equals: 1.
	self assert: i2 evaluate equals: 0.
	self assert: i1 print equals: '(if true then 1 else 0)'.
	self assert: i2 print equals: '(if false then 1 else 0)'.
	

]

{ #category : #tests }
GPArithmeticTest >> testDivNode [
	| i1 i2 c res|
	c := GPArithConfiguration new.
	"i1 = (24 / (4 * 3))"
	i1 := c divNode children: { c number: 24 . (c multNode children: { c number: 4 . c number: 3 }) }.
	
	"i2 = (5 / (1 + (2 - 3)))"	
	i2 := c divNode children: { c number: 5 . (c sumNode children: { c number: 1 . (c subNode children: {c number: 2 . c number: 3}) } ) }.
	
	res:= [ i2 evaluate] on: Exception do: [ 'div by zero' ].
	
	self assert: i1 evaluate equals: 2.
	self assert: res equals: 'div by zero'.
	self assert: i1 print equals: '(24 / (4 * 3))'.
	self assert: i2 print equals: '(5 / (1 + (2 - 3)))'.
	self assert: i1 numberOfNodes equals: 5.
	self assert: i2 numberOfNodes equals: 7.


]
