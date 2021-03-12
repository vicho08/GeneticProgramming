Class {
	#name : #GPPackage,
	#superclass : #Object,
	#instVars : [
		'classes',
		'info'
	],
	#category : #'GeneticProgramming-CodeGenerator'
}

{ #category : #accessing }
GPPackage >> classesTesting [
	^ classes select: [ :elem | (elem class canUnderstand: #buildSuite) ]
]

{ #category : #accessing }
GPPackage >> name: aPackage [

info:= (RPackageOrganizer default packageNamed: aPackage) .
classes := info classes asOrderedCollection .
]
