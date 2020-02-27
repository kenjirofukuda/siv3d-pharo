Class {
	#name : #Siv3DExamples,
	#superclass : #Object,
	#category : #'Siv3D-Examples'
}

{ #category : #examples }
Siv3DExamples >> exampleBackgroundColorChange [
	<script: 'self new exampleBackgroundColorChange open setLabel: ''BackgroundColorChange'' '>
	| canvas |
	canvas := RSCanvas new.
	canvas newAnimation
		repeat;
		onStepDo: [ :t | canvas color: (Color h: t * 360 s: 0.6 v: 1.0) ].
	^ canvas

"
# include <Siv3D.hpp>

void Main()
{
    while (System::Update())
    {
        const double hue = Scene::Time() * 60.0;

        Scene::SetBackground(HSV(hue, 0.6, 1.0));
    }
}
"
]

{ #category : #examples }
Siv3DExamples >> exampleCirclesWithCursor [
	<script:
		'self new exampleCirclesWithCursor open setLabel: ''Circles with cursor'' '>
	| canvas |
	canvas := RSCanvas new.
	canvas color: Color black.
	canvas
		add:
			(RSEllipse new
				size: 80;
				position: 100 @ 200;
				color: Color white;
				yourself).
	canvas
		add:
			(RSEllipse new
				size: 80;
				position: 200 @ 200;
				color: Color green;
				yourself).
	canvas
		add:
			(RSEllipse new
				size: 80;
				position: 300 @ 200;
				color: Color lightBlue;
				yourself).
	canvas
		add:
			(RSEllipse new
				size: 80;
				position: 400 @ 200;
				color: (Color r: 1.0 g: 0.8s b: 0.0);
				yourself).
	canvas
		add:
			(RSEllipse new
				size: 80;
				position: 500 @ 200;
				color: (Color fromRgb256Triplet: #(255 127 127));
				yourself).
	canvas
		add:
			(RSEllipse new
				size: 80;
				position: 600 @ 200;
				color: (Color h: 160 s: 1.0 v: 1.0);
				yourself).
	canvas
		add:
			(RSEllipse new
				size: 80;
				position: 700 @ 200;
				color: (Color h: 160 s: 0.75 v: 1.0);
				yourself).
	canvas
		add:
			(RSEllipse new
				size: 160;
				color:
					(Color
						r: 0.0
						g: 0.5
						b: 1.0
						alpha: 0.8);
				yourself).
	canvas
		when: RSMouseMove
		do: [ :evt | 
			canvas shapes last position: evt position.
			canvas signalUpdate ].
	canvas zoomToFit.
	^ canvas
"
# include <Siv3D.hpp>

void Main()
{
    while (System::Update())
    {
        // 左から順に 7 つの円を描く
        Circle(100, 200, 40).draw();

        Circle(200, 200, 40).draw(Palette::Green);

        Circle(300, 200, 40).draw(Palette::Skyblue);

        Circle(400, 200, 40).draw(ColorF(1.0, 0.8, 0.0));

        Circle(500, 200, 40).draw(Color(255, 127, 127));

        Circle(600, 200, 40).draw(HSV(160.0, 1.0, 1.0));

        Circle(700, 200, 40).draw(HSV(160.0, 0.75, 1.0));

        // 半透明の円
        Circle(Cursor::Pos(), 80).draw(ColorF(0.0, 0.5, 1.0, 0.8));
    }
}
"
]

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

{ #category : #examples }
Siv3DExamples >> exampleRectanglesWithCursor [
	<script:
		'self new exampleRectanglesWithCursor open setLabel: ''Rectangles with cursor'' '>
	| canvas b c |
	canvas := RSCanvas new.
	canvas extent: 800 @ 600.
	canvas color: Color black.
	b := RSBox new
		extent: 400 @ 100;
		position: 20 @ 40;
		color: Color white;
		yourself.
	b translateBy: (b extent // 2) negated.
	canvas add: b.
	c := RSBox new
		size: 80;
		position: 100 @ 200;
		color: Color orange;
		yourself.
	c translateBy: (c extent // 2) negated.
	canvas add: c.
	canvas
		add:
			(RSBox new
				extent: 80 @ 40;
				position: 400 @ 300;
				color: Color pink;
				yourself).
	canvas
		add:
			(RSBox new
				size: 100;
				color: (Color red alpha: 0.5);
				yourself).
	canvas
		add:
			(RSBox new
				extent: 390.5 @ 122.5;
				position: 200.4 @ 450.3;
				color: Color lightBlue;
				yourself).
	canvas
		when: RSMouseMove , RSMouseDragging
		do: [ :evt | 
			(canvas shapes at: canvas shapes size - 1) position: evt position.
			canvas signalUpdate ].
	canvas zoomToFit.
	^ canvas

	"
# include <Siv3D.hpp>

void Main()
{
    while (System::Update())
    {
        // 座標 (20, 40) を左上の基準位置にして、幅 400, 高さ 100 の長方形を描く 
        Rect(20, 40, 400, 100).draw();

        // 座標 (100, 200) を左上の基準位置にして、幅が 80 の正方形を描く 
        Rect(100, 200, 80).draw(Palette::Orange);

        // 座標 (400, 300) を中心の基準位置にして、幅 80, 高さ 40 の長方形を描く
        Rect(Arg::center(400, 300), 80, 40).draw(Palette::Pink);

        // マウスカーソルの座標を中心の基準位置にして、幅が 100 の正方形を描く 
        Rect(Arg::center(Cursor::Pos()), 100).draw(ColorF(1.0, 0.0, 0.0, 0.5));

        // 座標や大きさを浮動小数点数 (小数を含む数）で指定したい場合は RectF
        RectF(200.4, 450.3, 390.5, 122.5).draw(Palette::Skyblue);
    }
}
"
]
