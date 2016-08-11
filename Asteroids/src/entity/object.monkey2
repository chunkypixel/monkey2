
Class ObjectEntity Extends Entity
Private
	Field _scale:Vec2f
	Field _color:Color
	Field _blend:BlendMode
	Field _rotation:Float
	Field _direction:Float
	Field _visible:Bool
	Field _enabled:Bool
Public

	Method New()
		_scale=New Vec2f(1.0,1.0)
		_color=GetColor(224,224,224)
		_blend=BlendMode.Additive
		_rotation=0.0
		_direction=0.0
		_visible=True
		_enabled=True
	End

	#Rem monkeydoc Returns or sets the entity visibility flag.
	When set to False, the entity is not rendered.
	#End
	Property Visible:Bool() Virtual
		Return _visible
	Setter( value:Bool )
		_visible=value
	End

	#Rem monkeydoc Returns or sets the entity enabled flag.
	When set to False, the entity is not updated or rendered.
	#End
	Property Enabled:Bool() Virtual
		Return _enabled
	Setter( value:Bool )
		_enabled=value
	End
		
	#Rem monkeydoc Returns or sets the entity image scale.
	#End
	Property Scale:Vec2f()
		Return _scale
	Setter( value:Vec2f )
		_scale=value
	End

	#Rem monkeydoc Returns or sets the entity color value.
	Color class also includes Alpha.
	#End
	Property Color:Color()
		Return _color
	Setter( value:Color )
		_color=value
	End

	#Rem monkeydoc Returns or sets the entity rotation (in degrees)
	#End
	Property Rotation:Float()
		Return _rotation
	Setter( value:Float )
		_rotation=value
	End

	#Rem monkeydoc Returns or sets the entity direction (in degrees)
	#End	
	Property Direction:Float()
		Return _direction
	Setter( value:float )
		_direction=value
	End

	#Rem monkeydoc Returns or sets the entity rendering blend mode
	#End	
	Property BlendMode:BlendMode()
		Return _blend
	Setter( value:BlendMode )
		_blend=value
	End
		
End Class
 