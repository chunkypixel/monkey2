
Class PlayerEntity Extends ImageEntity

Private
	Field _velocity:Vec2f
	Field _acceleration:Vec2f
	Field _thrust:Float=0.1	'07
Public
	Field State:GameState
	
	Method New()
		Super.New(PlayerImage)
		_velocity=New Vec2f()
		_acceleration=New Vec2f()
	End
	
	Method Reset:Void()
		_velocity=New Vec2f(0,0)
		_acceleration=New Vec2f(0,0)
		Self.Rotation=90.0
		Self.Radius=6.0
		
		Self.Scale=New Vec2f(0.5,0.5)
		Self.BlendMode=BlendMode.Additive
		Self.Color=Color.White
		
		Self.ResetPosition(GAME.GameResolution.X/2,GAME.GameResolution.Y/2)
	End
	
	Method Update:Void() Override
		'Validate
		If (Self.X<-5) Self.ResetPosition(GAME.Width+5,Self.Y)
		If (Self.X>GAME.Width+5) Self.ResetPosition(-5,Self.Y)
		If (Self.Y<-5) Self.ResetPosition(Self.X,GAME.Height+5)
		If (Self.Y>GAME.Height+5) Self.ResetPosition(Self.X,-5)
		
		'Rotation
		If (KeyboardControlDown("LEFT")) Self.Rotation+=3
		If (KeyboardControlDown("RIGHT")) Self.Rotation-=3
		' analogue rotation. more is faster turn
		' a little deadzone of 0.1
		local value:Float=JoystickAxisValue("TURN")
		If (value<-0.1) Self.Rotation+=4*Abs(value)
		If (value>0.1) Self.Rotation-=4*value
		' check joy hat
		' if there is no hat, the value of 0 is returned
		' so it can be called without problem
		Local hatValue:JoystickHat=JoystickHatValue(0)
		If (hatValue=JoystickHat.Left) Self.Rotation+=3
		If (hatValue=JoystickHat.Right) Then Self.Rotation-=3
		'Validate
		If (Self.Rotation<0) Self.Rotation+=360
		If (Self.Rotation>360) Self.Rotation-=360

		'Thrust
		_acceleration=New Vec2f()
		If (KeyboardControlDown("THRUST") Or JoystickButtonDown("THRUST"))
			Local radian:=DegreesToRadians(Self.Rotation)
			_acceleration.X=Cos(radian)*_thrust
			_acceleration.Y=-Sin(radian)*_thrust	
		Endif
		
		'Fire
		If (KeyboardControlHit("FIRE") Or JoystickButtonHit("FIRE"))
			Local b:=New BulletEntity(Self.Rotation,New Vec2f(Self.X,Self.Y))
			b.State=Self.State
			AddEntity(b,LAYER_BULLETS)
			AddEntityToGroup(b,"bullets")
			'GAME.PlaySound("bullet")
		Endif
		
		'Update
		_velocity+=_acceleration
		_velocity*=0.99
		Self.Position+=_velocity
		
	End Method
	
	'Method Render(canvas:Canvas) Override
	'	canvas.TextureFilteringEnabled=True
	'	Super.Render(canvas)
	'	'canvas.TextureFilteringEnabled=True
	'	'canvas.BlendMode=BlendMode.Additive
	'	'canvas.Alpha=0.9
	'	'canvas.DrawImage(PlayerImage,Self.X,Self.Y)
	'End Method
	

End Class
