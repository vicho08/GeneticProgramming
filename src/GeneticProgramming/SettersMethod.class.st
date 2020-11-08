Class {
	#name : #SettersMethod,
	#superclass : #Object,
	#category : #'GeneticProgramming-CodeGenerator'
}

{ #category : #testing }
SettersMethod >> initialize [ 
	|body|
	(CompiledMethod selectors includes: #isSetter) ifTrue: [ ^ self ].
	
	body := 
		'isSetter' , String cr ,
		'   	| body astCache variableName |' , String cr, 
    	'   	(self selector select: [ :c | c = $: ]) size = 1 ifFalse: [ ^ false ]. ' , String cr,
 		'   	astCache := self ast.' , String cr ,    
      '   	variableName := astCache arguments first name.' , String cr ,    
    	'   	body := astCache body.' , String cr,
      '	 	body statements size = 1 ifFalse: [ ^ false ].' , String cr,
    	'		body children first class == RBAssignmentNode ifFalse: [ ^ false ].' , String cr,
    	'^ ((body children first variable name = self selector allButLast)
        and: [ body children first value class = RBVariableNode ])
        and: [ body children first value name = variableName ]'.
		CompiledMethod compile: body. 
]
