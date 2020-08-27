Class {
	#name : #CodeGeneratorTest04,
	#superclass : #TestCase,
	#instVars : [
		'x',
		'y',
		'c',
		'd'
	],
	#category : #'GeneticProgramming-CodeGenerator'
}

{ #category : #running }
CodeGeneratorTest04 >> setUp [
   c := RSLinePlot new.
   d := RSLinePlot new. 
	d color: Color red.
	c color: Color green.

]

{ #category : #tests }
CodeGeneratorTest04 >> testBasic [
    self assert: (d color) equals: (Color red).
]

{ #category : #tests }
CodeGeneratorTest04 >> testBasic01 [
    self assert: (c color) equals: (Color green).

]

{ #category : #tests }
CodeGeneratorTest04 >> testBasic02 [
	c color: Color red.
    self assert: (c color) equals: (d color).

]

{ #category : #tests }
CodeGeneratorTest04 >> testBasic03 [
	d color: Color white.
    self assert: (d color) equals: (Color white).

]
