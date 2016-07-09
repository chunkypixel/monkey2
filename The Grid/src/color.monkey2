'-----------------------------------------------------------------------
'
'  Based on the BlitzMax code of Grid Wars by Mark Incitti
'  - More examples to be completed
'  - Need to work out how to transfer over OpenGL calls
'
'  Code has been modulerized and Struct'd to reduce memory
'
'-----------------------------------------------------------------------

Class ColorCycler
Private
	Field _rColDelta:Float=-3
	Field _gColDelta:Float=5
	Field _bColDelta:Float=7
Public
	Field Red:Int=250
	Field Green:Int=20
	Field Blue:Int=30
	
	Method New()
	End
	
	Method Update(speed:Float=10)
		Self.Red=Self.Red+_rColDelta/10*speed
		If (Self.Red<0)
			Self.Red=0
			_rColDelta=Rnd(1,speed)
		Elseif (Self.Red>255)
			Self.Red=255
			_rColDelta=-Rnd(1,speed)
		End

		Self.Green=Self.Green+_gColDelta/10*speed
		If (Self.Green<0)
			Self.Green=0
			_gColDelta=Rnd(1,speed)
		Elseif (Self.Green>255)
			Self.Green=255
			_gColDelta=-Rnd(1,speed)
		End

		Self.Blue=Self.Blue+_bColDelta/10*speed
		If (Self.Blue<0)
			Self.Blue=0
			_bColDelta=Rnd(1,speed)
		Elseif (Self.Blue>255)
			Self.Blue=255
			_bColDelta=-Rnd(1,speed)
		End
		
	End
	
	Method Color:Color()
		Return GetColor(Self.Red,Self.Green,Self.Blue)
	End
	
End

Function GetColor:Color(red:Int,green:Int,blue:Int)
	Local r:Float=(Cast<Float>(red)/255)
	Local g:Float=(Cast<Float>(green)/255)
	Local b:Float=(Cast<Float>(blue)/255)
	Return New Color(r,g,b)
End