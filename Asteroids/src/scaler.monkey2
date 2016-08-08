
'Create in Game initialisation
Global VirtualResolution:ResolutionScaler

'-----------------------------------------------------------------------------------------------
' VirtualResolution usage:
' - Set a virtual screen based on the specified resolution
' - All objects should be plotted within this resolution
' - Objects will be automatically scaled up using the ResolutionScaler
'-----------------------------------------------------------------------------------------------

Class ResolutionScaler
Private
	Field _scale:Vec2f
	Field _size:=New Vec2i(640,480)
Public

	Method New(width:Float,height:Float)
		_scale=New Vec2f(width/_size.x,height/_size.y)
	End Method
	
' Properties (Scale)
	Property Scale:Vec2f()
		Return _scale
	End	
	Property sx:Float()
		Return _scale.x
	End	
	Property sy:Float()
		Return _scale.y
	End
	Property Best:Float()
		Return Min(_scale.X,_scale.Y)
	End
	
' Proeprties (Screen)
	Property Size:Vec2i()
		Return _size
	End
	Property Width:Int()
		Return _size.x
	End	
	Property Height:Int()
		Return _size.y
	End
	
End Class