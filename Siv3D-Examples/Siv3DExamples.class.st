Class {
	#name : #Siv3DExamples,
	#superclass : #Object,
	#category : #'Siv3D-Examples'
}

{ #category : #examples }
Siv3DExamples class >> contentsOfMethod: aSelector [
	^ (self class >> aSelector) sourceCode lines allButFirst joinUsing: String cr

]

{ #category : #examples }
Siv3DExamples class >> exampleCursorPoint [
	GTPlayground
		openContents: (self contentsOfMethod: #scriptCursorPoint)
]

{ #category : #examples }
Siv3DExamples class >> exampleKDTree [
	"https://scrapbox.io/Siv3D/KDTree"
	GTPlayground
		openContents: (self contentsOfMethod: #scriptKDTreeView)
]

{ #category : #examples }
Siv3DExamples class >> scriptCursorPoint [
	| v e |
	v := RTView new.
	e := RTEllipse new
		size: 30;
		element.
	v add: e.
	e model: e.
	e @ (RTLabeled new text: [ :m | m position ]).
	e @ RTDraggable.
	e translateTo: 30 @ 40.
	e
		when: TRMouseDragging
		do: [ :evt | 
			| rounded |
			rounded := (e position x round: 3) @ (e position y round: 3).
			"e position traceCr."
			(e attributeAt: #RTLabelledLabel) text: rounded printString ].
	v when: TRMouseMove do: [ :evt | evt position traceCr ].
	^ v
]

{ #category : #examples }
Siv3DExamples class >> scriptKDTreeView [
	| v randPoint randRadius randDirection cursorElement ellipses numSample cursorPoint anim tree result |
	v := RTView new.
	v canvas color: Color black.
	randPoint := [ v canvas extent x atRandom
		@ v canvas extent y atRandom ].
	randDirection := [ (PMUniformDistribution
		from: -10.0 degreesToRadians
		to: 10.0 degreesToRadians) random ].
	numSample := 8.
	randRadius := [ (PMUniformDistribution from: 0.2 to: 1.0) random ].
	cursorElement := RTEllipse new
		size: 25;
		color: Color transparent;
		element.
	v add: cursorElement.
	ellipses := OrderedCollection new.
	v when: TRMouseMove do: [ :evt | cursorPoint := evt position ].
	200
		timesRepeat: [ 
			| e |
			e := RTEllipse new
				size: (6 to: 16) atRandom;
				color: Color random;
				element.
			e @ RTDraggable.
			e translateTo: randPoint value.
			v add: e.
			ellipses add: e.
			e
				attributeAt: #direction
				put:
					(PMUniformDistribution
						from: 0.0 degreesToRadians
						to: 360 degreesToRadians) random ].
	anim := RTActiveAnimation new.
	anim intervalInMilliseconds: 1.0 / 60.0 * 1000.
	anim
		blockToExecute: [ 
			| lines |
			v removeAllEdges.
			ellipses
				do: [ :e | 
					| direction |
					direction := e attributeAt: #direction.
					direction := direction + randDirection value.
					e attributeAt: #direction put: direction.
					e
						translateBy: (SivCircular r: randRadius value theta: direction) asPoint ].
			cursorPoint
				ifNotNil: [ cursorElement translateTo: cursorPoint.
					tree := SivKDTree new.
					tree vectorBlock: [ :e | e position asArray ].
					tree elements: ellipses.
					result := tree nnSearch: cursorPoint asArray i: numSample.
					lines := RTLine edgesFrom: cursorElement toAll: result.
					lines
						do: [ :l | 
							l trachelShape
								width: 6.0;
								color: Color white ].
					v addAll: lines.
					result traceCr ] ].
	anim inView: v.
	^ v
]
