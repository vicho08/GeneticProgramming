Class {
	#name : #VisualizationGame,
	#superclass : #Object,
	#instVars : [
		'game',
		'player',
		'frames'
	],
	#category : #'GeneticProgramming-MarioGame'
}

{ #category : #accessing }
VisualizationGame >> animation [
	|c counter|
	c := RSCanvas new.
	counter:= 0.
	Transcript show: (self getEscenarys at:11) ; cr.
	c newAnimation repeat
    duration: 1 seconds;
    when: RSAnimationLoopEvent do: [ :evt|
            counter := (counter + 1) \\ (self getEscenarys size).
        		self buildEscenary: (counter+1)  canvas: c].

	^ c.
]

{ #category : #hooks }
VisualizationGame >> buildEscenary [
	|e shapes c fond box sky obstacles|
	
	e := self getEscenarys at: 11.	
	shapes := e collect: [ :char |
        ((self dictionary) at: char) value.
         ] as: RSGroup.

	fond := e collect: [ :char |
        	box := RSBox new size: 30; color: (Color r:1 g:0.66 b:0);scaleBy: (1@3).
         ] as: RSGroup.
	obstacles := e collect: [ :char |
		(char = #O) ifTrue: [ self obstacleShape  ]
		ifFalse:[RSBox new size: 30; color: Color transparent ;scaleBy: (1@2) ]] as: RSGroup.
	sky := e collect: [ :char |
        	box := RSBox new size: 30; color: (Color r:0 g:0.66 b:0.89);scaleBy: (1@2).
         ] as: RSGroup.
	
	c := RSCanvas new.
	c addAll: sky.
	c addAll: fond.	
	c addAll: obstacles.
	c addAll: shapes.
	RSHorizontalLineLayout new gapSize: 0; on: shapes.
	RSHorizontalLineLayout new gapSize: 0; on: fond.
	RSHorizontalLineLayout new gapSize: 0; on: sky.
	RSHorizontalLineLayout new gapSize: 0; on: obstacles.
	shapes translateTo: 210@55.
	sky translateTo: 210@(10).
	fond translateTo: 210@(70).
	obstacles translateTo: 210@(50).
	
	
	^ c  
]

{ #category : #hooks }
VisualizationGame >> buildEscenary: aIndex [
	|e shapes c fond box sky obstacles|
	
	e := self getEscenarys at: aIndex.	
	shapes := e collect: [ :char |
        ((self dictionary) at: char) value.
         ] as: RSGroup.

	fond := e collect: [ :char |
        	box := RSBox new size: 30; color: (Color r:1 g:0.66 b:0);scaleBy: (1@3).
         ] as: RSGroup.
	obstacles := e collect: [ :char |
		(char = #O) ifTrue: [ self obstacleShape  ]
		ifFalse:[RSBox new size: 30; color: Color transparent ;scaleBy: (1@2) ]] as: RSGroup.
	sky := e collect: [ :char |
        	box := RSBox new size: 30; color: (Color r:0 g:0.66 b:0.89);scaleBy: (1@2).
         ] as: RSGroup.
	
	c := RSCanvas new.
	c addAll: sky.
	c addAll: fond.	
	c addAll: obstacles.
	c addAll: shapes.
	RSHorizontalLineLayout new gapSize: 0; on: shapes.
	RSHorizontalLineLayout new gapSize: 0; on: fond.
	RSHorizontalLineLayout new gapSize: 0; on: sky.
	RSHorizontalLineLayout new gapSize: 0; on: obstacles.
	shapes translateTo: 210@55.
	sky translateTo: 210@(10).
	fond translateTo: 210@(70).
	obstacles translateTo: 210@(50).
	
	
	^ c
]

{ #category : #hooks }
VisualizationGame >> buildEscenary: aIndex canvas: canvas [
	|e shapes fond sky obstacles i jumping|
	
	e := self getEscenarys at: aIndex.
	i := self getEscenarys at: 1. 	
	shapes := e collect: [ :char |
        ((self dictionary) at: char) value.
         ] as: RSGroup.

	fond := e collect: [ :char |
        	RSBox new size: 30; color: (Color r:1 g:0.66 b:0);scaleBy: (1@3).
         ] as: RSGroup.
	obstacles := i collect: [ :char |
		(char = #O) ifTrue: [ self obstacleShape  ]
		ifFalse:[RSBox new size: 30; color: Color transparent ]] as: RSGroup.
	
	jumping := i collect: [ :char |
		(char = #jump) ifTrue: [ self jumpShape  ]
		ifFalse:[RSBox new size: 30; color: Color transparent ].] as: RSGroup.
	sky := e collect: [ :char |
        	RSBox new size: 30; color: (Color r:0 g:0.66 b:0.89);scaleBy: (1@2).
         ] as: RSGroup.
	
	canvas shapes: RSGroup new.
	canvas addAll: sky.
	canvas addAll: fond.
	canvas addAll: obstacles.
	canvas addAll: shapes.
	"c addAll: jumping."
	RSHorizontalLineLayout new gapSize: 0; on: shapes.
	RSHorizontalLineLayout new gapSize: 0; on: fond.
	RSHorizontalLineLayout new gapSize: 0; on: sky.
	RSHorizontalLineLayout new gapSize: 0; on: obstacles.
	RSHorizontalLineLayout new gapSize: 0; on: jumping.
	jumping translateTo: 210@45.
	shapes translateTo: 210@55.
	sky translateTo: 210@(10).
	fond translateTo: 210@(70).
	obstacles translateTo: 210@(80).
]

{ #category : #accessing }
VisualizationGame >> dictionary [ 
	^{ 
		#E -> [self enemyShape].
      #_ -> [RSBox new size: 30; color: (Color r:1 g:0.66 b:0)].
      #O -> [RSBox new size: 30; color: Color transparent ].
      #H -> [self walkShape].
		#F -> [self fireShape ].
		#shoot -> [ self shootShape ].
		#jump -> [self jumpShape].
      #'$' -> [self goalShape].
	 } asDictionary.
]

{ #category : #accessing }
VisualizationGame >> enemyPath [
	^'M102.421,429.132v31.523c0,11.226,9.096,20.321,20.321,20.321s20.321-9.096,20.321-20.321v-19.956
			c9.25,2.024,18.899,3.764,28.889,5.202v14.753c0,11.226,9.096,20.321,20.321,20.321c11.226,0,20.321-9.096,20.321-20.321v-10.738
			c9.202,0.512,18.566,0.805,28.1,0.805c10.388,0,20.598-0.333,30.588-0.935v10.868c0,11.226,9.096,20.321,20.321,20.321
			c11.226,0,20.321-9.096,20.321-20.321v-15.103c9.998-1.496,19.647-3.3,28.889-5.381v20.492c0,11.226,9.096,20.321,20.321,20.321
			c11.226,0,20.321-9.096,20.321-20.321V428.23c21.841-8.153,39.651-18.167,52.039-29.466c12.502-11.388,19.517-24.069,19.517-37.44
			c0-4.715-0.878-9.332-2.544-13.851c-8.754-41.066-59.534-76.791-59.534-76.791c-10.348-5.397-17.728-17.826-22.971-31.449
			c-3.845,0.008-7.901,0.561-12.64,2.032c-0.764,0.236-1.536,0.488-2.3,0.723c-15.135,4.731-30.767,9.925-46.243,13.054
			c-3.633,0.732-7.129,1.244-10.559,1.642c-27.466,3.203-49.007-4.243-71.621-23.28c-20.484-17.241-6.178-42.732,14.241-48.406
			v33.36h41.594v-20.939c10.185,1.74,21.874-0.951,33.319-4.674v31.035h10.982h30.328h0.285v-3.609v-31.71v-8.381
			c0.114-0.016,0.219-0.016,0.333-0.033C350.245,79.156,298.084,0,234.494,0c-67.199,0-121.685,88.39-121.685,197.419
			c-8.657,73.287-18.623,45.943-54.632,89.398s-29.799,74.498-29.799,74.498C28.378,388.448,57.112,412.737,102.421,429.132z
			 M218.351,105.541c0-16.46,13.339-29.799,29.799-29.799h40.976c16.46,0,29.799,13.339,29.799,29.799v13.656
			c0,16.46-13.339,29.799-29.799,29.799H248.15c-16.46,0-29.799-13.339-29.799-29.799
			C218.351,119.197,218.351,105.541,218.351,105.541z'.
]

{ #category : #accessing }
VisualizationGame >> enemyShape [
	|monsterShape|
	monsterShape := RSSVGPath new svgPath: (self enemyPath ); color: Color red; size:30.
	monsterShape scaleBy: (-1@2).
	^ monsterShape.
]

{ #category : #'as yet unclassified' }
VisualizationGame >> firePath [
	^'M398.239,235.891l-0.278-1.111C357.041,106.465,235.114,15.368,229.929,11.572L214.191,0l1.019,19.441
			c0,0.834,2.869,76.193-70.176,138.868c-79.34,68.138-78.878,124.334-78.692,154.515l0.094,4.166
			c0,82.302,60.399,143.839,146.811,153.984c-4.704-0.739-9.509-1.698-14.331-3.172c-27.867-8.61-44.16-28.144-47.308-56.289
			l-0.74-5.554c-2.5-21.756-5.74-48.697,41.845-99.801c17.775-19.071,33.236-39.624,46.012-61.01l6.388-10.738l8.424,9.257
			c25.182,27.495,44.438,55.269,57.399,82.302c11.942,23.886,12.684,61.659,11.757,69.713
			c-4.536,41.105-34.254,71.749-74.063,76.192c-2.595,0.296-6.479,0.583-11.234,0.689c0.418,0.003,0.816,0.051,1.236,0.051
			c94.06,0,167.66-75.637,167.66-172.197C406.293,277.274,398.516,237.557,398.239,235.891z'
]

{ #category : #accessing }
VisualizationGame >> fireShape [
	^ RSSVGPath new svgPath: (self firePath ); color: Color red; size:30; scaleBy: (1@2).

]

{ #category : #accessing }
VisualizationGame >> frames [
	^frames
]

{ #category : #accessing }
VisualizationGame >> frames: theFrames [
	frames:= theFrames.
]

{ #category : #accessing }
VisualizationGame >> game [
	^game
]

{ #category : #accessing }
VisualizationGame >> game: aGame [
	game:= aGame
]

{ #category : #accessing }
VisualizationGame >> getEscenarys [
	| es pos esc put ant copy |
	es := OrderedCollection new.
	frames
		doWithIndex: [ :g :i | 
			pos := g position x.
			esc := g escenary.
			put := #H.
			i = 1
				ifTrue: [ esc at: 1 put: put ]
				ifFalse: [ (ant = pos)
						ifTrue: [ put := #shoot.
							copy := esc copy.
							copy at: pos put: put.
							copy at: (pos+1) put: #F.
							es add: copy. 
							put:= #H].
					(ant + 2 = pos)
						ifTrue: [ put := #jump.
							copy := esc copy.
							copy at: pos - 1 put: put.
							copy at: pos put: #_.
							es add: copy.
							put:= #H].
						esc at: pos put: put.].
			es add: esc.
			ant := pos ].
	^ es
]

{ #category : #accessing }
VisualizationGame >> goalPath [
	^ 'M189.798,31.551c0-4.143-3.357-7.5-7.5-7.5h-79.453c-4.143,0-7.5,3.357-7.5,7.5v47.687c0,4.143,3.357,7.5,7.5,7.5h71.953
	v21.186L102.845,179.9l-18.532-18.54c-1.571-1.571-3.769-2.362-5.97-2.168c-2.213,0.197-4.225,1.365-5.493,3.189L1.342,265.221
	c-1.594,2.292-1.782,5.28-0.488,7.755c1.293,2.476,3.855,4.026,6.647,4.026h286.035c0.008,0.001,0.016,0.001,0.02,0
	c4.143,0,7.5-3.357,7.5-7.5c0-1.783-0.622-3.421-1.661-4.708L189.798,108.66V31.551z M110.345,71.738V39.051h64.453v32.687H110.345z
	 M21.85,262.003l58.195-83.694l17.495,17.503c1.407,1.406,3.315,2.197,5.305,2.197c1.989,0,3.897-0.791,5.304-2.197l73.141-73.165
	l97.818,139.357H21.85z'
]

{ #category : #accessing }
VisualizationGame >> goalShape [
	^RSSVGPath new svgPath: (self goalPath ); size:30; color: Color black; scaleBy: (1@2).
]

{ #category : #initialization }
VisualizationGame >> initialize [
	|g|
	super initialize.
	self game: Game new.
	g := GPMarioGame new.
	self player: g example.
	self frames: (g games: (self player)).
	
	
]

{ #category : #'as yet unclassified' }
VisualizationGame >> jumpPath [
	^'M225.336,94.43c5.391,3.627,11.495,6.139,17.868,7.384l0.063,0.013c15.79,3.063,32.396-2.02,43.783-13.378
				c11.549-11.527,16.62-28.571,13.254-44.541c-3.277-15.555-14.274-28.871-28.958-34.979c-15.025-6.251-32.545-4.517-46.039,4.578
				c-13.496,9.094-21.675,24.682-21.523,40.957C203.938,70.365,212.152,85.555,225.336,94.43z M47.864,86.749l98.012,37.197L54.36,202.201c-6.005,5.124-7.41,14.035-2.973,20.813
				c4.814,7.354,14.68,9.413,22.033,4.599l75.031-49.123c0,0-13.668,41.7-14.765,44.514c-5.019,12.871,1.347,27.374,14.219,32.393
				l91.474,35.666l55.544,69.561c6.641,8.295,18.734,9.93,27.327,3.537c8.785-6.535,10.609-18.955,4.074-27.74l-50.64-68.072
				l15.581,1.844l69.977,41.217c9.133,5.363,20.985,2.613,26.753-6.381c5.911-9.219,3.228-21.48-5.989-27.391l-72.493-46.479
				c-2.043-1.297-4.447-2.285-6.974-2.744l-1.083-0.197l-69.863-12.684c0,0,32.531-96.01-5.286-113.515L60.92,49.315
				c-9.956-3.15-20.81,1.974-24.561,11.858C32.473,71.413,37.624,82.863,47.864,86.749z'
]

{ #category : #accessing }
VisualizationGame >> jumpShape [
	^RSSVGPath new svgPath: (self jumpPath ); color: Color blue; size: 30; scaleBy: (1@2).
]

{ #category : #'as yet unclassified' }
VisualizationGame >> obstaclePath [ 
	^ 'M385.894,204.222h-0.246c-26.398,0-47.875,21.477-47.875,47.876v65.98c0,4.212-3.427,7.638-7.639,7.638
	H301.03V79.874C301.03,35.831,265.199,0,221.156,0c-44.042,0-79.873,35.831-79.873,79.874v86.585h-25.04
	c-2.592,0-4.701-2.109-4.701-4.702v-50.728c0-23.03-18.736-41.766-41.767-41.766h-0.001c-22.624,0-41.03,18.407-41.03,41.032v73.086
	c0,36.324,29.553,65.875,65.879,65.875h46.66v198.256c0,8.284,6.716,15,15,15H286.03c8.284,0,15-6.716,15-15v-25.8h49.871
	c45.693,0,82.868-37.171,82.868-82.86v-86.755C433.769,225.699,412.292,204.222,385.894,204.222z M141.283,219.256h-46.66
	c-19.784,0-35.879-16.093-35.879-35.875v-73.086c0-6.083,4.948-11.032,11.031-11.032c6.488,0,11.767,5.278,11.767,11.766v50.728
	c0,19.135,15.566,34.702,34.701,34.702h25.04V219.256z M271.03,432.513h-99.747V79.874c0-27.5,22.373-49.874,49.873-49.874
	c27.501,0,49.874,22.373,49.874,49.874V432.513z M403.769,338.852c0,29.147-23.717,52.86-52.868,52.86H301.03v-35.997h29.104
	c20.754,0,37.639-16.884,37.639-37.638v-65.98c0-9.857,8.019-17.876,17.875-17.876h0.246c9.856,0,17.875,8.019,17.875,17.875
	V338.852z'
]

{ #category : #accessing }
VisualizationGame >> obstacleShape [
	^ RSSVGPath new svgPath: (self obstaclePath ); color: Color green; size: 30; scaleBy: (1@1).
	
]

{ #category : #accessing }
VisualizationGame >> player [
	^ player
]

{ #category : #accessing }
VisualizationGame >> player: aPlayer [
	player := aPlayer.
]

{ #category : #'as yet unclassified' }
VisualizationGame >> shootPath [
	^'M148.204,202.609l1.379,23.581c0.237,4.028,2.331,7.717,5.669,9.982c3.32,2.252,7.519,2.856,11.369,1.58l12.621-4.183
			L148.204,202.609z M511.983,153.352c-0.304-5.214-4.628-9.238-9.784-9.238c-0.193,0-0.387,0.006-0.582,0.017l-14.706,0.86l-0.501-8.569
			c-0.306-5.214-4.628-9.238-9.784-9.238c-0.193,0-0.387,0.006-0.582,0.017c-5.409,0.317-9.536,4.957-9.221,10.366l0.501,8.569
			l-79.533,4.652l-19.782-35.024c-1.92-3.335-5.518-5.35-9.365-5.218l-79.706,2.543c-4.735,0.151-8.772,3.476-9.829,8.094
			l-5.615,24.55l21.907-1.093l2.237-10.971l65.423-2.087l11.491,20.567l-14.716,0.861c13.8,20.885,5.559,48.911-16.953,59.171
			l-6.104,2.782l10.304,30.286c3.954,11.623,16.581,17.832,28.194,13.879c11.618-3.953,17.832-16.575,13.879-28.194
			c-11.117-32.675-8.724-25.643-13.659-40.147l37.381-2.186c5.409-0.317,9.536-4.957,9.221-10.366
			c-0.247-4.218-3.128-7.647-6.949-8.806l97.611-5.708C508.172,163.402,512.299,158.762,511.983,153.352z M206.773,53.045c-26.768-4.088-51.798,14.296-55.888,41.077c-4.526,29.623,18.376,56.458,48.543,56.458
			c23.815,0,44.716-17.381,48.423-41.647C251.941,82.157,233.549,57.134,206.773,53.045z M336.32,166.143c-5.09-11.167-18.271-16.092-29.436-11.004l-81.045,36.939c-8.178-4.584-66.046-37.059-74.61-41.822
			c-11.75-6.535-16.266-19.697-16.266-19.697c-9.933-0.071-19.482,3.832-26.521,10.839c-7.039,7.008-10.984,16.54-10.957,26.472
			c0.528,61.581,0.432,111.869,0.351,133.039c-0.027,6.905,1.002,13.896,3.043,20.491c4.407,14.247,13.026,43.684,22.571,84.787
			H26.665C11.938,406.19,0,418.128,0,432.855c0,14.727,11.938,26.665,26.665,26.665h130.432c8.143,0,15.84-3.721,20.898-10.103
			c5.058-6.382,6.922-14.726,5.063-22.652l-22.422-95.568l73.378-7.277l-16.648,104.75c-2.567,16.15,9.895,30.854,26.367,30.854
			c12.883,0,24.216-9.358,26.302-22.483l22.072-138.882c1.298-8.162-1.263-16.465-6.933-22.479
			c-5.67-6.014-13.805-9.059-22.032-8.242l-57.92,5.744l0.148-13.942c-2.717-2.2-2.532-2.137-15.431-15.003l-19.073,6.32
			c-7.552,2.502-16.143,1.556-23.185-3.223c-6.761-4.588-11.083-12.198-11.56-20.356c-1.913-32.717-2.021-31.378-1.465-35.068
			c14.386,8.063-4.26-2.388,79.287,44.443c6.176,3.464,13.635,3.775,20.079,0.838l91.297-41.612
			C336.484,190.488,341.41,177.31,336.32,166.143z'
]

{ #category : #accessing }
VisualizationGame >> shootShape [
	^RSSVGPath new svgPath: (self shootPath ); color: Color blue; size:30; scaleBy: (1@2).

	
]

{ #category : #accessing }
VisualizationGame >> show [
	^ (self showJump )@ RSCanvasController
]

{ #category : #accessing }
VisualizationGame >> showEnemy [
	|c monsterShape|
	c := RSCanvas new.
	monsterShape := RSSVGPath new svgPath: (self enemyPath ); color: Color red.
	c add: monsterShape.
	monsterShape scaleBy: (-1@1).
	^ c.
]

{ #category : #accessing }
VisualizationGame >> showJump [
	|c jumpShape|
	c := RSCanvas new.
	jumpShape := RSSVGPath new svgPath: (self jumpPath ); color: Color blue.
	c add: jumpShape.
	^ c.
]

{ #category : #accessing }
VisualizationGame >> showObstacle [
	|c obstacleShape|
	c := RSCanvas new.
	obstacleShape := RSSVGPath new svgPath: (self obstaclePath ); color: Color green.
	c add: obstacleShape.
	obstacleShape scaleBy: (-1@1).
	^ c.
]

{ #category : #accessing }
VisualizationGame >> showWalk [
	|c walkShape |
	c := RSCanvas new.
	walkShape := RSSVGPath new svgPath: (self shootPath  ); color: Color blue.
	c add: walkShape.
	^ c.
]

{ #category : #'as yet unclassified' }
VisualizationGame >> walkPath [
	^'M67.971,49.778l-9.378-10.345c-0.584-0.644-1.121-1.971-1.148-2.841L57.1,25.858v-0.311c0-1.654-1.346-3-3-3h-9.18h-3.648
		c-1.478,0-3.127,1.047-3.756,2.384l-12.358,26.25c-0.342,0.728-0.376,1.541-0.096,2.292c0.28,0.75,0.84,1.342,1.575,1.666
		l1.821,0.803c0.388,0.171,0.802,0.258,1.231,0.258h0c1.177,0,2.273-0.669,2.794-1.704l5.789-11.517v11.576
		c-0.024,0.067-0.059,0.128-0.081,0.196l-9.783,30.638c-0.407,1.276-0.283,2.619,0.35,3.781s1.693,1.994,2.987,2.343l0.654,0.177
		c0.428,0.116,0.872,0.175,1.318,0.175c2.251,0,4.296-1.481,4.974-3.603l9.141-28.628l3.242,7.941
		c0.791,1.937,1.645,5.329,1.865,7.409l1.551,14.621c0.249,2.341,2.1,4.04,4.402,4.04c0.377,0,0.76-0.046,1.137-0.137l0.659-0.16
		c2.624-0.635,4.478-3.331,4.133-6.008l-2.297-17.828c-0.292-2.265-1.269-5.812-2.178-7.907l-3.102-7.144
		c-0.04-0.093-0.097-0.177-0.143-0.267v-4.841l5.59,5.836c0.556,0.581,1.3,0.901,2.094,0.901c0.803,0,1.553-0.326,2.111-0.918
		l1.034-1.098C69.036,52.899,69.055,50.973,67.971,49.778z M48.52,20.005c5.516,0,10.003-4.487,10.003-10.003C58.523,4.487,54.036,0,48.52,0c-5.515,0-10.001,4.487-10.001,10.002
		C38.518,15.518,43.005,20.005,48.52,20.005z'
]

{ #category : #accessing }
VisualizationGame >> walkShape [
	^RSSVGPath new svgPath: (self walkPath ); color: Color blue; size:30;  scaleBy: (1@2).

	
]
