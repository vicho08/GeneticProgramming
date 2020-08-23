Class {
	#name : #CodeGeneratorTest03,
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
CodeGeneratorTest03 >> setUp [

	 x := -10 to: 20 by: 1.
    y := x.
    c := RSChart new.
    d := RSLinePlot new. 
	 d x: x y: y.

]

{ #category : #tests }
CodeGeneratorTest03 >> testBasic [
    self assert: (d minValueX) equals: (d minValueY).
]

{ #category : #tests }
CodeGeneratorTest03 >> testBasic02 [
	 y :=  x negated.
	 d x: x y: y.
    self assert: (d minValueY) equals: -20.
]

{ #category : #tests }
CodeGeneratorTest03 >> testBasic03 [
    self assert: -10 equals: (d minValueY).
]

{ #category : #tests }
CodeGeneratorTest03 >> testBasic04 [
	 c addPlot: d.
    self assert: (c minValueY) equals: (d minValueY).
]
