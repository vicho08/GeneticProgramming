Class {
	#name : #CodeGeneratorTest,
	#superclass : #TestCase,
	#instVars : [
		'c'
	],
	#category : #'GeneticProgramming-CodeGenerator'
}

{ #category : #running }
CodeGeneratorTest >> setUp [
|x y d q|

	 x := -3.14 to: 3.14 by: 0.1.
    y := x cos.
    c := RSChart new.
    d := RSLinePlot new. 
	 d color: Color red.
	 d x: x y: y.
	
(c red). "<== adding line"
c build
]

{ #category : #running }
CodeGeneratorTest >> tearDown [

	(SystemWindow allInstances select: [ :w | w label beginsWith: 'a RSAthensMorph' ] ) do: #delete
]

{ #category : #tests }
CodeGeneratorTest >> testBasic [
    self assert: c canvas shapes size equals: 2.
]

{ #category : #tests }
CodeGeneratorTest >> testBasic01 [
    self assert: c canvas shapes second class equals: RSPolyline
]

{ #category : #tests }
CodeGeneratorTest >> testBasic02 [
    self assert: c canvas shapes second color equals: Color red
]

{ #category : #tests }
CodeGeneratorTest >> testBasic03 [
    self assert: c class equals: RSChart
]
