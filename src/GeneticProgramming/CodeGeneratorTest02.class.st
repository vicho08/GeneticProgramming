Class {
	#name : #CodeGeneratorTest02,
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
CodeGeneratorTest02 >> setUp [

	 x := -10 to: 20 by: 1.
    y := x.
    c := RSChart new.
    d := RSLinePlot new. 
	 d x: x y: y.

]

{ #category : #tests }
CodeGeneratorTest02 >> testBasic [
    self assert: (d maxValueX) equals: (d maxValueY).
]

{ #category : #tests }
CodeGeneratorTest02 >> testBasic02 [
	 y :=  x negated.
	 d x: x y: y.
    self assert: (d maxValueY) equals: 10.
]

{ #category : #tests }
CodeGeneratorTest02 >> testBasic03 [
    self assert: 20 equals: (d maxValueY).
]

{ #category : #tests }
CodeGeneratorTest02 >> testBasic04 [
	 c addPlot: d.
    self assert: (c maxValueY) equals: (d maxValueY).
]
