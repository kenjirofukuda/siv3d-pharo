Class {
	#name : #SivCircular,
	#superclass : #Object,
	#instVars : [
		'oclock',
		'r',
		'theta'
	],
	#category : #'Siv3D-Model'
}

{ #category : #'instance creation' }
SivCircular class >> new [
	^ self oclock: 0.
]

{ #category : #'instance creation' }
SivCircular class >> oclock: anOclock [
	^ self basicNew initialize oclock: anOclock; yourself 
]

{ #category : #'instance creation' }
SivCircular class >> r: aRadius theta: aTheta [
	^ self new r: aRadius theta: aTheta.
]

{ #category : #converting }
SivCircular >> asPoint [
	"
[[nodiscard]] Vec2 toVec2() const noexcept
		{
			return{ std::sin(theta + Clock()) * r, -std::cos(theta + Clock()) * r };
		}
		"

	^ ((theta + self clock) sin * r) @ ((theta + self clock) cos * r) negated
]

{ #category : #private }
SivCircular >> clamp: aTheta [
	^ aTheta <= Float twoPi negated
		ifTrue: [ aTheta + Float twoPi ]
		ifFalse: [ aTheta ]
]

{ #category : #accessing }
SivCircular >> clock [
	^ self oclock * (Float twoPi / 12)
]

{ #category : #initialization }
SivCircular >> initialize [
	super initialize.
	oclock := 0.
	r := 0.0.
	theta := 0.0.
]

{ #category : #accessing }
SivCircular >> negated [
	^ self class new
		r: self r;
		theta: (self clamp: self theta - Float pi);
		yourself
]

{ #category : #accessing }
SivCircular >> oclock [
	^ oclock
]

{ #category : #accessing }
SivCircular >> oclock: anObject [
	oclock := anObject
]

{ #category : #private }
SivCircular >> offset: aTheta [
	^ self clamp: (aTheta - self clock)
]

{ #category : #accessing }
SivCircular >> r [
	^ r
]

{ #category : #accessing }
SivCircular >> r: anObject [
	r := anObject
]

{ #category : #initialization }
SivCircular >> r: aRadius theta: aTheta [
	r := aRadius.
	theta := aTheta.
]

{ #category : #accessing }
SivCircular >> theta [
	^ theta
]

{ #category : #accessing }
SivCircular >> theta: anObject [
	theta := anObject
]
