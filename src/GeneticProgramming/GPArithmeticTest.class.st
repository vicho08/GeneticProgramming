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
