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
		do: [ 
			spec 
				baseline: 'PolyMath' 
				with: [ spec repository: 'github://PolyMathOrg/PolyMath:v1.0.1/src' ].
			spec
				configuration: 'Roassal2'
				with: [ spec repository: 'http://smalltalkhub.com/mc/ObjectProfile/Roassal2/main' ].
			spec package: 'Siv3D-Model' with: [ spec requires: #('PolyMath') ].
			spec package: 'Siv3D-Examples' with: [ spec requires: #('Siv3D-Model' 'Roassal2') ].
			spec group: #default with: [ spec requires: #('Siv3D-Examples') ] ]
]
