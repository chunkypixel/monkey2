'-----------------------------------------------------------------------
'
'  Based on the BlitzMax code of Grid Wars by Mark Incitti
'
'-----------------------------------------------------------------------

Class ColorCycle
Private
	Field _rColDelta:Float=-3
	Field _gColDelta:Float=5
	Field _bColDelta:Float=7
Public
	Field Red:Float=250
	Field Green:Float=20
	Field Blue:Float=30
		
	Method Update(speed:Float=10.0)

		Self.Red+=(_rColDelta/10*speed)
		If (Self.Red<0)
			Self.Red=0
			_rColDelta=Rnd(1,speed)
		Elseif (Self.Red>255)
			Self.Red=255
			_rColDelta=-Rnd(1,speed)
		End

		Self.Green+=(_gColDelta/10*speed)
		If (Self.Green<0)
			Self.Green=0
			_gColDelta=Rnd(1,speed)
		Elseif (Self.Green>255)
			Self.Green=255
			_gColDelta=-Rnd(1,speed)
		End

		Self.Blue+=(_bColDelta/10*speed)
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

Function GetColor:Color(red:Float,green:Float,blue:Float)
	Return New Color(red/255,green/255,blue/255)
End