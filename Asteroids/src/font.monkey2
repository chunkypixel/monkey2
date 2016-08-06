
Global VectorFont:=New FontManager()

Class FontManager
Private
	Field _chars:FontChar[]
Public

	Method New()
		Self.Initialise()
	End Method 
	
	Method DrawFont(canvas:Canvas,text:String,y:Float,scale:Float)
		Local textLength:Float=Self.Length(text.Length,scale)
		Self.DrawFont(canvas,text,640/2-textLength/2,y,scale)
	End
	
	Method DrawFont:Void(canvas:Canvas,text:String,x:Float,y:Float,scale:Float)
		'Canvas
		canvas.LineWidth=GetLineWidth(2.0)	'For now make all lines >1.0 for smoothing
		canvas.Color=GetColor(224,224,224)
		canvas.Alpha=GetAlpha()

		'Make uppercase (for now)
		text=text.ToUpper()
						
		'Process
		For Local index:Int=0 Until text.Length
			'Prepare
			Local char:FontChar=_chars[text.Mid(index,1)[0]]
						
			'Draw			
			For Local point:Int=0 Until char.Points
				canvas.DrawLine(New Vec2f(char.RenderPoints[point].x1*scale+x+scale*5*index,char.RenderPoints[point].y1*scale+y)*ResolutionScaler.Size,
									New Vec2f(char.RenderPoints[point].x2*scale+x+scale*5*index,char.RenderPoints[point].y2*scale+y)*ResolutionScaler.Size)				
			Next
			
		Next
		
		'Reset
		canvas.Color=Color.White
		canvas.Alpha=1.0
	End
		
	Method Length:Float(chars:Int,scale:Float)
		Return (scale*5*chars)
	End Method
	
Private
	Method Initialise:Void()
		'Load
		_chars=New FontChar[128]
		For Local t:Int=32 To 127
			_chars[t]=New FontChar()
			'Validate
			Select t
				Case 32 ' Space
				Case 33	' !
					_chars[t].AddPoint(2,0, 2,4)
					_chars[t].AddPoint(2,5, 2,6)
				Case 34	' ""
					_chars[t].AddPoint(1,1, 1,3)
					_chars[t].AddPoint(3,1, 3,3)
				Case 35	' #
					_chars[t].AddPoint(1,0, 1,6)
					_chars[t].AddPoint(3,0, 3,6)
					_chars[t].AddPoint(0,2, 4,2)
					_chars[t].AddPoint(0,4, 4,4)
				Case 36	' $
					_chars[t].AddPoint(0,1, 0,3)
					_chars[t].AddPoint(0,3, 4,3)
					_chars[t].AddPoint(4,3, 4,5)
					_chars[t].AddPoint(4,5, 0,5)
					_chars[t].AddPoint(0,1, 4,1)
					_chars[t].AddPoint(2,0, 2,6)
				Case 37	' %
					_chars[t].AddPoint(3,0, 1,6)
					_chars[t].AddPoint(1,1, 1,2)
					_chars[t].AddPoint(3,4, 3,5)
				Case 38	' &
					_chars[t].AddPoint(0,1, 4,5)
					_chars[t].AddPoint(0,1, 1,0)
					_chars[t].AddPoint(1,0, 2,1)
					_chars[t].AddPoint(2,1, 0,4)
					_chars[t].AddPoint(0,4, 2,6)
					_chars[t].AddPoint(2,6, 4,4)
				Case 39	' '
					_chars[t].AddPoint(3,1, 2,2)
				Case 40	' (
					_chars[t].AddPoint(3,0, 1,2)
					_chars[t].AddPoint(1,2, 1,4)
					_chars[t].AddPoint(1,4, 3,6)
				Case 41	' )
					_chars[t].AddPoint(1,0, 3,2)
					_chars[t].AddPoint(3,2, 3,4)
					_chars[t].AddPoint(3,4, 1,6)
				Case 42	' *
					_chars[t].AddPoint(1,1, 3,5)
					_chars[t].AddPoint(1,5, 3,1)
					_chars[t].AddPoint(0,3, 4,3)
				Case 43	' +
					_chars[t].AddPoint(2,2, 2,4)
					_chars[t].AddPoint(1,3, 3,3)
				Case 44	' ,
					_chars[t].AddPoint(2,5, 1,6)
				Case 45	' -
					_chars[t].AddPoint(1,3, 3,3)
				Case 46	' .
					_chars[t].AddPoint(2,5, 2,6)
				Case 47	' /
					_chars[t].AddPoint(4,0, 0,6)
				Case 48	' 0
					_chars[t].AddPoint(0,0, 0,6)
					_chars[t].AddPoint(0,6, 4,6)
					_chars[t].AddPoint(4,6, 4,0)
					_chars[t].AddPoint(4,0, 0,0)
				Case 49	' 1
					_chars[t].AddPoint(2,0, 2,6)
				Case 50	' 2
					_chars[t].AddPoint(0,0, 4,0)
					_chars[t].AddPoint(4,0, 4,3)
					_chars[t].AddPoint(4,3, 0,3)
					_chars[t].AddPoint(0,3, 0,6)
					_chars[t].AddPoint(0,6, 4,6)
				Case 51	' 3
					_chars[t].AddPoint(0,0, 4,0)
					_chars[t].AddPoint(4,0, 4,6)
					_chars[t].AddPoint(4,6, 0,6)
					_chars[t].AddPoint(2,3, 4,3)
				Case 52	' 4
					_chars[t].AddPoint(0,0, 0,3)
					_chars[t].AddPoint(0,3, 4,3)
					_chars[t].AddPoint(4,0, 4,6)
				Case 53	' 5
					_chars[t].AddPoint(0,0, 4,0)
					_chars[t].AddPoint(0,0, 0,3)
					_chars[t].AddPoint(0,3, 4,3)
					_chars[t].AddPoint(4,3, 4,6)
					_chars[t].AddPoint(0,6, 4,6)
				Case 54	' 6
					_chars[t].AddPoint(0,0, 0,6)
					_chars[t].AddPoint(0,3, 4,3)
					_chars[t].AddPoint(4,3, 4,6)
					_chars[t].AddPoint(0,6, 4,6)
				Case 55	' 7
					_chars[t].AddPoint(0,0, 4,0)
					_chars[t].AddPoint(4,0, 4,6)
				Case 56	' 8
					_chars[t].AddPoint(0,0, 0,6)
					_chars[t].AddPoint(0,6, 4,6)
					_chars[t].AddPoint(4,6, 4,0)
					_chars[t].AddPoint(4,0, 0,0)
					_chars[t].AddPoint(0,3, 4,3)
				Case 57	' 9
					_chars[t].AddPoint(0,0, 4,0)
					_chars[t].AddPoint(4,0, 4,6)
					_chars[t].AddPoint(0,0, 0,3)
					_chars[t].AddPoint(0,3, 4,3)
				Case 58	' :
					_chars[t].AddPoint(2,1, 2,1)
					_chars[t].AddPoint(2,5, 2,5)
				Case 59	' ;
					_chars[t].AddPoint(2,1, 2,1)
					_chars[t].AddPoint(2,5, 2,6)
				Case 60	' <
					_chars[t].AddPoint(4,0, 1,3)
					_chars[t].AddPoint(1,3, 4,6)
				Case 61	' =
					_chars[t].AddPoint(1,2, 3,2)
					_chars[t].AddPoint(1,4, 3,4)
				Case 62	' >
					_chars[t].AddPoint(0,0, 3,3)
					_chars[t].AddPoint(3,3, 0,6)
				Case 63	' ?
					_chars[t].AddPoint(1,1, 1,0)
					_chars[t].AddPoint(1,0, 3,0)
					_chars[t].AddPoint(3,0, 3,2)
					_chars[t].AddPoint(3,2, 2,3)
					_chars[t].AddPoint(2,3, 2,4)
					_chars[t].AddPoint(2,5, 2,6)
				Case 64	' @
					_chars[t].AddPoint(2,2, 2,4)
					_chars[t].AddPoint(2,4, 4,4)
					_chars[t].AddPoint(4,4, 4,0)
					_chars[t].AddPoint(4,0, 0,0)
					_chars[t].AddPoint(0,0, 0,6)
					_chars[t].AddPoint(0,6, 4,6)				
				Case 65	' A
					_chars[t].AddPoint(2,0, 0,2)
					_chars[t].AddPoint(2,0, 4,2)
					_chars[t].AddPoint(0,2, 0,6)
					_chars[t].AddPoint(4,2, 4,6)
					_chars[t].AddPoint(0,3, 4,3)
				Case 66	' B
					_chars[t].AddPoint(0,0, 0,6)
					_chars[t].AddPoint(0,6, 4,6)
					_chars[t].AddPoint(4,6, 4,3)
					_chars[t].AddPoint(4,3, 0,3)
					_chars[t].AddPoint(0,0, 3,0)
					_chars[t].AddPoint(3,0, 3,3)
				Case 67	' C
					_chars[t].AddPoint(0,0, 0,6)
					_chars[t].AddPoint(0,6, 4,6)
					_chars[t].AddPoint(0,0, 4,0)
				Case 68	' D
					_chars[t].AddPoint(0,0, 0,6)
					_chars[t].AddPoint(0,6, 2,6)
					_chars[t].AddPoint(2,6, 4,4)
					_chars[t].AddPoint(4,4, 4,2)
					_chars[t].AddPoint(4,2, 2,0)
					_chars[t].AddPoint(2,0, 0,0)
				Case 69	' E
					_chars[t].AddPoint(0,0, 0,6)
					_chars[t].AddPoint(0,6, 4,6)
					_chars[t].AddPoint(0,0, 4,0)
					_chars[t].AddPoint(0,3, 2,3)
				Case 70	' F
					_chars[t].AddPoint(0,0, 0,6)
					_chars[t].AddPoint(0,0, 4,0)
					_chars[t].AddPoint(0,3, 2,3)
				Case 71	' G
					_chars[t].AddPoint(0,0, 0,6)
					_chars[t].AddPoint(0,6, 4,6)
					_chars[t].AddPoint(0,0, 4,0)
					_chars[t].AddPoint(4,6, 4,3)
					_chars[t].AddPoint(4,3, 2,3)
				Case 72	' H
					_chars[t].AddPoint(0,0, 0,6)
					_chars[t].AddPoint(0,3, 4,3)
					_chars[t].AddPoint(4,0, 4,6)
				Case 73 ' I
					_chars[t].AddPoint(0,0, 4,0)
					_chars[t].AddPoint(0,6, 4,6)
					_chars[t].AddPoint(2,0, 2,6)
				Case 74	' J
					_chars[t].AddPoint(3,0, 4,0)
					_chars[t].AddPoint(4,0, 4,6)
					_chars[t].AddPoint(4,6, 2,6)
					_chars[t].AddPoint(2,6, 1,4)
				Case 75	' K
					_chars[t].AddPoint(0,0, 0,6)
					_chars[t].AddPoint(0,3, 2,3)
					_chars[t].AddPoint(2,3, 4,0)
					_chars[t].AddPoint(2,3, 4,6)
				Case 76	' L
					_chars[t].AddPoint(0,0, 0,6)
					_chars[t].AddPoint(0,6, 4,6)
				Case 77	' M
					_chars[t].AddPoint(0,0, 0,6)
					_chars[t].AddPoint(0,0, 2,3)
					_chars[t].AddPoint(2,3, 4,0)
					_chars[t].AddPoint(4,0, 4,6)
				Case 78	' N
					_chars[t].AddPoint(0,0, 0,6)
					_chars[t].AddPoint(0,0, 4,6)
					_chars[t].AddPoint(4,6, 4,0)
				Case 79	' O
					_chars[t].AddPoint(0,0, 0,6)
					_chars[t].AddPoint(0,6, 4,6)
					_chars[t].AddPoint(4,6, 4,0)
					_chars[t].AddPoint(4,0, 0,0)
				Case 80	' P
					_chars[t].AddPoint(0,0, 0,6)
					_chars[t].AddPoint(0,0, 4,0)
					_chars[t].AddPoint(0,3, 4,3)
					_chars[t].AddPoint(4,3, 4,0)
				Case 81	' Q
					_chars[t].AddPoint(0,0, 0,6)
					_chars[t].AddPoint(0,6, 2,6)
					_chars[t].AddPoint(2,6, 4,4)
					_chars[t].AddPoint(4,4, 4,0)
					_chars[t].AddPoint(4,0, 0,0)
					_chars[t].AddPoint(4,6, 2,4)
				Case 82	' R
					_chars[t].AddPoint(0,0, 0,6)
					_chars[t].AddPoint(0,0, 4,0)
					_chars[t].AddPoint(0,3, 4,3)
					_chars[t].AddPoint(4,0, 4,3)
					_chars[t].AddPoint(2,3, 4,6)
				Case 83	' S
					_chars[t].AddPoint(0,0, 0,3)
					_chars[t].AddPoint(0,3, 4,3)
					_chars[t].AddPoint(4,3, 4,6)
					_chars[t].AddPoint(4,6, 0,6)
					_chars[t].AddPoint(0,0, 4,0)
				Case 84	' T
					_chars[t].AddPoint(0,0, 4,0)
					_chars[t].AddPoint(2,0, 2,6)
				Case 85	' U
					_chars[t].AddPoint(0,0, 0,6)
					_chars[t].AddPoint(0,6, 4,6)
					_chars[t].AddPoint(4,6, 4,0)
				Case 86	' V
					_chars[t].AddPoint(0,0, 0,3)
					_chars[t].AddPoint(0,3, 2,6 )
					_chars[t].AddPoint(2,6, 4,3)
					_chars[t].AddPoint(4,3, 4,0)
				Case 87	' W
					_chars[t].AddPoint(0,0, 1,6)
					_chars[t].AddPoint(1,6, 2,4)
					_chars[t].AddPoint(2,4, 3,6)
					_chars[t].AddPoint(3,6, 4,0)
				Case 88 ' X
					_chars[t].AddPoint(0,0, 4,6)
					_chars[t].AddPoint(0,6, 4,0)
				Case 89	' Y
					_chars[t].AddPoint(0,0, 2,3)
					_chars[t].AddPoint(2,3, 4,0)
					_chars[t].AddPoint(2,3, 2,6)
				Case 90	' Z
					_chars[t].AddPoint(0,0, 4,0)
					_chars[t].AddPoint(4,0, 0,6)
					_chars[t].AddPoint(0,6, 4,6)
				Case 91	' [
					_chars[t].AddPoint(3,0, 1,0)
					_chars[t].AddPoint(1,0, 1,6)
					_chars[t].AddPoint(1,6, 3,6)
				Case 92	' \
					_chars[t].AddPoint(0,0, 4,6)
				Case 93	' ]
					_chars[t].AddPoint(1,0, 3,0)
					_chars[t].AddPoint(3,0, 3,6)
					_chars[t].AddPoint(3,6, 1,6)
				Case 94	' ^
					_chars[t].AddPoint(1,2, 2,0)
					_chars[t].AddPoint(2,0, 3,2)
				Case 95	' -
					_chars[t].AddPoint(0,7, 4,7)
				Case 96	' `
					_chars[t].AddPoint(1,1, 2,2 )
				Case 97	' a
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
				Case 98	' b
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
				Case 99	' c
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
				Case 100' d
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
				Case 101' e
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
				Case 102' f
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
				Case 103' g
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
				Case 104' h
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
				Case 105' i
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
				Case 106' j
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
				Case 107' k
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
				Case 108' l
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
				Case 109' m
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
				Case 110' n
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
				Case 111' o
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
				Case 112' p
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
				Case 113' q	
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
				Case 114' r
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
				Case 115' s
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
				Case 116' t
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
				Case 117' u
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
				Case 118' v
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
				Case 119' w
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
				Case 120' x
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
				Case 121' y
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
				Case 122' z
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
'					_chars[t].AddPoint( )
				Case 123' {
					_chars[t].AddPoint(3,0, 2,0)
					_chars[t].AddPoint(2,0, 2,6)
					_chars[t].AddPoint(2,6, 3,6)
					_chars[t].AddPoint(1,3, 2,3)
				Case 124' |
					_chars[t].AddPoint(2,0, 2,6)
				Case 125' }
					_chars[t].AddPoint(1,0, 2,0)
					_chars[t].AddPoint(2,0, 2,6)
					_chars[t].AddPoint(2,6, 1,6)
					_chars[t].AddPoint(2,3, 3,3)
				Case 126' <-
					_chars[t].AddPoint(3,1, 0,3)
					_chars[t].AddPoint(0,3, 3,5)
					_chars[t].AddPoint(0,3, 4,3)
				Case 127' Checkmark
					_chars[t].AddPoint(0,4, 2,6)
					_chars[t].AddPoint(2,6, 4,0)
				Case 128' ->
					_chars[t].AddPoint(1,1, 4,3)
					_chars[t].AddPoint(4,3, 1,5)
					_chars[t].AddPoint(0,3, 4,3)				
			End Select
			
		Next
		
	End Method
	
End Class

Class FontChar
Private
	Field _points:Int=0
	Field _renderPoints:VectorChar[]
Public
	
	Property RenderPoints:VectorChar[]()
		Return _renderPoints
	End
	Property Points:Int()
		Return _points
	End
	
	Method New()
		_renderPoints=New VectorChar[8]
	End

	Method AddPoint(x1:Float,y1:Float,x2:Float,y2:Float)
		_renderPoints[_points].x1=x1
		_renderPoints[_points].y1=y1
		_renderPoints[_points].x2=x2
		_renderPoints[_points].y2=y2
		_points+=1
	End
End Class

Struct VectorChar
	Field x1:Float
	Field y1:Float
	Field x2:Float
	Field y2:Float
End Struct