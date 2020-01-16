Class {
	#name : #SivKDTree,
	#superclass : #Object,
	#instVars : [
		'vectorBlock',
		'dim',
		'value',
		'left',
		'right'
	],
	#category : #'Siv3D-Model'
}

{ #category : #'instance creation' }
SivKDTree class >> withAll: aCollectionOfCollections [
	"make a KDTree from a Collection of SequenceableCollections ,which is a Collection of points in a n-dimensional space"
	^ self new
		addData: aCollectionOfCollections asOrderedCollection
		at: 1
]

{ #category : #adding }
SivKDTree >> add: aDistance to: aNNStore [
	aNNStore add: {aDistance . value} .
]

{ #category : #adding }
SivKDTree >> addData: aSequenceableCollection at: dimension [
	| sorted cut nextDimension |
	dim := dimension.
	aSequenceableCollection size = 1
		ifTrue: [ value := aSequenceableCollection first.
			self adjustValue.
			^ self ].
	sorted := self sort: aSequenceableCollection.
	cut := (sorted size + 1) // 2.
	value := sorted at: cut.
	self adjustValue.
	nextDimension := dimension \\ (self vectorFor: value) size + 1.
	cut > 1
		ifTrue: [ left := self class new vectorBlock: vectorBlock ;
				addData: (sorted copyFrom: 1 to: cut - 1)
				at: nextDimension ].
	right := self class new vectorBlock: vectorBlock ;
		addData: (sorted copyFrom: cut + 1 to: sorted size)
		at: nextDimension
]

{ #category : #private }
SivKDTree >> adjustValue [
]

{ #category : #accessing }
SivKDTree >> dimValueFor: aModel [
	^ (vectorBlock value: aModel) at: dim
]

{ #category : #accessing }
SivKDTree >> elements: aModelCollection [
	^ self 
		addData: aModelCollection asOrderedCollection
		at: 1
]

{ #category : #accessing }
SivKDTree >> farChild: aVector [
	^ (self dimValueFor: value) < (aVector at: dim)
		ifTrue: [ left ]
		ifFalse: [ right ]
]

{ #category : #accessing }
SivKDTree >> nearChild: aVector [
	^ (self dimValueFor: value) < (aVector at: dim)
		ifTrue: [ right ]
		ifFalse: [ left ]
]

{ #category : #evaluating }
SivKDTree >> nnSearch: aVector i: anInt [
	"search for i nearest neighbours of vector aSequenceableCollection and return the vectors "
	| n |
	n := PMNNStore new: anInt.
	self nnSearch: aVector  near: n.
	n := n data.
	^ anInt = 1
		ifTrue: [ n first ]
		ifFalse: [ n ]
]

{ #category : #private }
SivKDTree >> nnSearch: aVector near: aNNStore [
	| dist |
	(self nearChild: aVector)
		ifNotNil: [ :c | c nnSearch: aVector near: aNNStore ].
	aNNStore maxDistance
		<
			((dist := (self dimValueFor: value)
				- (aVector at: dim)) * dist)
		ifTrue: [ ^ self ].
	dist := ((dist := aVector
		- (self vectorFor: value)) * dist) sum.
	self add: dist to: aNNStore.
	(self farChild: aVector)
		ifNotNil: [ :c | c nnSearch: aVector near: aNNStore ]
]

{ #category : #printing }
SivKDTree >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: ' (dim: ';
		print: dim;
		nextPutAll: ' value: ';
		print: value;
		nextPutAll: ' left: ';
		print: left;
		nextPutAll: ' right: ';
		print: right;
		nextPut: $)
]

{ #category : #sorting }
SivKDTree >> sort: aSequenceableCollection [
	^ aSequenceableCollection
		sort: [ :a :b | (self dimValueFor: a) < (self dimValueFor: b) ]
]

{ #category : #accessing }
SivKDTree >> vectorBlock: aVectorBlock [
	vectorBlock := aVectorBlock.
]

{ #category : #accessing }
SivKDTree >> vectorFor:  aModel [
	^ vectorBlock value: aModel
]
