Class {
	#name : #BaselineOfSiv3D,
	#superclass : #BaselineOf,
	#category : #BaselineOfSiv3D
}

{ #category : #baselines }
BaselineOfSiv3D >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				baseline: 'PolyMath'
				with: [ spec
						repository: 'github://PolyMathOrg/PolyMath/src' ].
			spec
				baseline: 'Roassal3'
				with: [ spec
						repository: 'github://ObjectProfile/Roassal3' ].
			spec package: 'Siv3D-Model' with: [ spec requires: #('PolyMath') ].
			spec package: 'Siv3D-Examples' with: [ spec requires: #('Siv3D-Model' 'Roassal3') ].
			spec group: 'default' with: #('Siv3D-Examples') ]
]
