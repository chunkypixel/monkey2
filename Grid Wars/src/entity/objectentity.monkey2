
Class ObjectEntity Extends Entity
Private
	Field _scale:Vec2f
	Field _rotation:Float
	Field _color:Color
	Field _blend:BlendMode
	Field _angle:Float
	Field _visible:Bool
	Field _collision:Bool
Public

	Method New()
		Self.Initialize()
	End

	#Rem monkeydoc Returns or sets the entity collision flag.
	When set to False, the entity does not participate in collision checks.
	#End
	Property Collision:Bool()
		Return _collision
	Setter( value:Bool )
		_collision = value
	End

	#Rem monkeydoc Returns or sets the entity visibility flag.
	When set to False, the entity is not rendered.
	#End
	Property Visible:Bool()
		Return _visible
	Setter( value:Bool )
		_visible = value
	End
	
	#Rem monkeydoc Returns or sets the entity image scale.
	#End
	Property Scale:Vec2f()
		Return _scale
	Setter( value:Vec2f )
		_scale = value
	End

	#Rem monkeydoc Returns or sets the entity color value.
	Color class also includes Alpha.
	#End
	Property Color:Color()
		Return _color
	Setter( value:Color )
		_color = value
	End

	#Rem monkeydoc Returns or sets the entity rotation (in degrees)
	#End
	Property Rotation:Float()
		Return _rotation
	Setter( value:Float )
		_rotation = value
	End

	Property BlendMode:BlendMode()
		Return _blend
	Setter( value:BlendMode )
		_blend = value
	End

	#Rem monkeydoc Returns or sets the entity angle/direction (in degrees)
	#End	
	Property Angle:Float()
		Return _angle
	Setter( value:float )
		_angle = value
	End
		
Private
	#Rem monkeydoc @hidden
	#End
	Method Initialize:Void()
		_scale=New Vec2f(1.0,1.0)
		_rotation=0.0
		_color=Color.White
		_blend=BlendMode.Alpha
		_visible=True
		_collision=True
	End Method	
	
End Class
 