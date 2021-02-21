Class {
	#name : #GPEngineGeneratorCode,
	#superclass : #GPEngine,
	#instVars : [
		'infoRoulette',
		'nameFile'
	],
	#category : #'GeneticProgramming-Core'
}

{ #category : #adding }
GPEngineGeneratorCode >> addAnswerToFile [

	| stream ind fit |
	stream := nameFile asFileReference writeStream.
	ind := self pickBestIndividual.
	fit := self fitnessOfBestIndividual.
	stream setToEnd.
	stream
		nextPutAll: ind print , ' ; ' , fit asString , ';';
		nextPutAll: String cr.
	stream close
]

{ #category : #adding }
GPEngineGeneratorCode >> addLog: aDictionary [
	|log best gen worse|
	log := GPLog new.
	gen := aDictionary at: #gen.
	best := aDictionary at: #best.
	worse := aDictionary at: #worse.
	log generation: gen.
	log bestFitnessValue: best.
	log worstFitnessValue: worse.
	logs add: log.
]

{ #category : #adding }
GPEngineGeneratorCode >> addToFile: aDictionary [
"put info to the end of file"
	|file stream gen best worse time|
	file := nameFile asFileReference. 
	stream:= file writeStream. 
	gen := aDictionary at: #gen.
	best := aDictionary at: #best.
	worse := aDictionary at: #worse.
	time := aDictionary at: #time.
	stream setToEnd.
	stream nextPutAll: (gen asString) , ' ; ' , (best asString) , ' ; ' , (worse asString) , ';' , 
	(time asString) , String cr.
	stream close.
]

{ #category : #evolution }
GPEngineGeneratorCode >> createNewGeneration [
	"The argument is a collection of GPNode, each element being the root node of an individual."
	"check if problem solved"
	| newInd newInd2 newInds newPopulation sizeHalf n_calls|
	(self distanceFromSolutionOf: self pickBestIndividual) = 0 ifTrue: [ ^ self ].
	
	newPopulation := OrderedCollection new. 
	newPopulation add: self pickBestIndividual.
	sizeHalf := ((population size -1) / 2.0) ceiling.
	sizeHalf timesRepeat: [
		newInds := self repeatOperatorsGenetics.
		newInd := newInds at: 1.
		newInd2 := newInds at: 2.
		n_calls:= (self configuration ) randomCalls.
		[self verifyCallsMethods: ({newInd . newInd2} asOrderedCollection) value: n_calls] whileFalse: [ 
		newInds:= self repeatOperatorsGenetics. 
		newInd := newInds at:1.
		newInd2 := newInds at: 2.].
		[(self verifyArguments: {newInd. newInd2})] whileFalse: [
		
		newInds:= self repeatOperatorsGenetics. 
		newInd := newInds at:1.
		newInd2 := newInds at: 2.  ].
		newPopulation add: newInd.
		newPopulation add: newInd2.  
	].
	
	population := newPopulation.
	fitnessOfPopulation := self totalFitnessOfGeneration 
]

{ #category : #hooks }
GPEngineGeneratorCode >> execute [

	"
	Execute the technique
	"

	| best worse start time dict|
	self createInitialPopulation.
	UIManager default informUserDuring: [ :bar | 
		1 to: configuration numberOfGenerations do: [ :gen | 
			bar label: gen asString.
			self microPause.
			start := Time now.
			self createNewGeneration.
			time := Time now asDuration - start asDuration.
			best := self fitnessOfBestIndividual.
			worse := self fitnessOfWorstIndividual .
			dict:= (Dictionary newFrom: { #gen -> gen. #best -> best. #worse -> worse . #time -> time}).
			
			self addLog: dict.			
			self addToFile: dict.

			self fitnessOfBestIndividual = 0 ifTrue: 
			[ 
			self addAnswerToFile. 
			^ self ] ] ].
			self addAnswerToFile. 
]

{ #category : #initialization }
GPEngineGeneratorCode >> initialize [ 
	super initialize.
	infoRoulette := 0.
]

{ #category : #hooks }
GPEngineGeneratorCode >> nameFile: aNameFile [
	nameFile:= aNameFile
]

{ #category : #'as yet unclassified' }
GPEngineGeneratorCode >> repeatOperatorsGenetics [
 	|i1 i2 newInds|
		i1 := self  rouletteSelection .
		i2 := self rouletteSelection .
		newInds := i1 crossOverTwoChildrenWith: i2 using: configuration random.
		((configuration randomInt: 100) > 70)
			ifTrue: [ self mutation: (newInds at: 1) ].
		((configuration randomInt: 100) > 70)
			ifTrue: [ self mutation: (newInds at: 2) ].
		^ newInds
]

{ #category : #evolution }
GPEngineGeneratorCode >> rouletteSelection [
	"Return the best individual from a rouletteSelection"
	|p sum|
	
	p := configuration randomElementOf: (0 to: infoRoulette).
	sum:= 0.
	^ population detect:  [ :individual |
		|dis val|
		dis:= (self distanceFromSolutionOf: individual).
		val := (dis * -1 + ((self configuration) totalTests)).
		(val > 0) ifTrue:[ sum := sum + val].
		(sum >= p).
	].
]

{ #category : #evolution }
GPEngineGeneratorCode >> totalFitnessOfGeneration [
	|total totalTests|
	total:= 0.
	infoRoulette := 0.
	totalTests:= (self configuration) totalTests.
	population do: [ :individual  | 
		|dis info|
		dis := (self distanceFromSolutionOf: individual).
		total := total + dis.
		info := (dis * -1) + totalTests.
		(info > 0 )
		ifTrue: [infoRoulette := infoRoulette +info] . ].
	^total
]

{ #category : #'as yet unclassified' }
GPEngineGeneratorCode >> verifyArguments: theIndividuals [
 ^ (configuration verifyArgument: (theIndividuals first)) and: (configuration verifyArgument: (theIndividuals second))
]

{ #category : #'as yet unclassified' }
GPEngineGeneratorCode >> verifyCallMethod: individual value: val [
	^ individual countCallMethods <= val
]

{ #category : #'as yet unclassified' }
GPEngineGeneratorCode >> verifyCallsMethods: individuals value: val [
	^ (self verifyCallMethod: (individuals at: 1) value: val) and: (self verifyCallMethod: (individuals at: 2) value: val) 
]
