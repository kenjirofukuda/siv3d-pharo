Class {
	#name : #Siv3DExamples,
	#superclass : #Object,
	#category : #'Siv3D-Examples'
}

{ #category : #examples }
Siv3DExamples >> exampleCursorPoint [
	<script: 'self new exampleCursorPoint open setLabel: ''Drag Me'' '>
	| c e |
	c := RSCanvas new.
	e := RSEllipse new
		draggable;
		size: 30.
	c add: e.
	e model: e.
	e translateTo: 30 @ 40.
	e @ (RSLabeled new text: [ :m | m position ]).
	e
		when: RSMouseDragging
		do: [ :evt | 
			| rounded |
			rounded := (e position x round: 3) @ (e position y round: 3).
			(e attributeAt: #RSLabeled) text: rounded printString ].
	c when: RSMouseMove do: [ :evt | evt position traceCr ].
	^ c
]

{ #category : #examples }
Siv3DExamples >> exampleKDTreeView [
	<script: 'self new exampleKDTreeView open setLabel: ''KDTree'' '>
	"CURRENT:  https://scrapbox.io/Siv3D/KDTree"
	"TODO:     https://siv3d.github.io/reference/kd-tree/"
	| canvas randPoint randRadius randDirection cursorElement ellipses numSample cursorPoint tree result |
	canvas := RSCanvas new.
	canvas canvas color: Color black.
	randPoint := [ canvas extent x atRandom @ canvas extent y atRandom ].
	randDirection := [ (PMUniformDistribution
		from: -10.0 degreesToRadians
		to: 10.0 degreesToRadians) random ].
	numSample := 8.
	randRadius := [ (PMUniformDistribution from: 0.2 to: 1.0) random ].
	cursorElement := RSEllipse new
		size: 25;
		color: Color transparent;
		yourself.
	canvas add: cursorElement.
	ellipses := OrderedCollection new.
	canvas when: RSMouseMove do: [ :evt | cursorPoint := evt position ].
	200
		timesRepeat: [ | e |
			e := RSEllipse new
				size: (6 to: 16) atRandom;
				draggable;
				color: Color random;
				yourself.
			e translateTo: randPoint value.
			canvas add: e.
			ellipses add: e.
			e
				attributeAt: #direction
				put:
					(PMUniformDistribution
						from: 0.0 degreesToRadians
						to: 360 degreesToRadians) random ].
	canvas newAnimation
		repeat;
		delay: (1.0 / 60.0 * 1000) milliSeconds;
		onStepDo: [ :t | 
			| lines |
			canvas edges copy do: #remove.
			ellipses
				do: [ :e | 
					| direction |
					direction := e attributeAt: #direction.
					direction := direction + randDirection value.
					e attributeAt: #direction put: direction.
					e
						translateBy: (SivCircular r: randRadius value theta: direction) asPoint ].
			cursorPoint
				ifNotNil: [ 
					cursorElement translateTo: cursorPoint.
					tree := SivKDTree new.
					tree vectorBlock: [ :e | e position asArray ].
					tree elements: ellipses.
					result := tree nnSearch: cursorPoint asArray i: numSample.
					lines := result
						collect: [ :each | 
							RSLine new
								from: cursorElement;
								to: each;
								color: Color white;
								width: 6;
								yourself ].
					canvas addAll: lines ] ].
	canvas camera position: canvas shapes encompassingRectangle center.
	^ canvas
]
