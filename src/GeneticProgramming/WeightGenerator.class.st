Class {
	#name : #WeightGenerator,
	#superclass : #Object,
	#instVars : [
		'dictionary'
	],
	#category : #'GeneticProgramming-CodeGenerator'
}

{ #category : #accessing }
WeightGenerator >> compare: aName with: otherName [
"Distance of Levenshtein"
	| s1 s2 l1 l2 ans a c |
	s1 := aName asArray.
	s2 := otherName asArray.
	l1 := s1 size.
	l2 := s2 size.

	"Base Case"
	l1 = 0
		ifTrue: [ ^ l2 ].
	l2 = 0
		ifTrue: [ ^ l1 ].
	c := 0.
	a := l1 + 1.
	ans := Dictionary new.
	0 to: l1 do: [ :i | ans at: i put: i ].
	0 to: l2 do: [ :i | ans at: i * a put: i ].
	
	1 to: l1 do: [ :i | 
		1 to: l2 do: [ :j | 
			| r s t |
			c := (s1 at: i) = (s2 at: j)
				ifTrue: [ 0 ]
				ifFalse: [ 1 ].
			r := ans at: j * a + i - 1.
			s := ans at: (j - 1) * a + i.
			t := ans at: (j - 1) * a + i - 1.
			r := r + 1.
			s := s + 1.
			t := t + c.
			ans at: j * a + i put: (t min: (r min: s)) ] ].
	^ ans at: l2 * a + l1
]

{ #category : #'as yet unclassified' }
WeightGenerator >> getDefault [ 
	^dictionary at: #_default_
]

{ #category : #'as yet unclassified' }
WeightGenerator >> getWeigth: aMethod [ 
	^dictionary at: aMethod
]

{ #category : #accessing }
WeightGenerator >> initialWeights: anArray [
	dictionary:= Dictionary newFrom: anArray
]

{ #category : #'as yet unclassified' }
WeightGenerator >> initialiaze [
	super initialize. 
]

{ #category : #accessing }
WeightGenerator >> methods [
	^dictionary keys
]

{ #category : #'as yet unclassified' }
WeightGenerator >> searchWeight: aMethod [
	(self methods includes: aMethod)
	ifTrue: [ ^self getWeigth: aMethod  ]
	ifFalse: [ ^self getDefault ].
]
