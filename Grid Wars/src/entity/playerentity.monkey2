
Class PlayerEntity Extends VectorEntity

Private
	Field _velocity:=New Vec2f
	Field _acceleration:=New Vec2f
	Field _thrust:Float=0.1	'07
Public
	Field State:GameState
	
	Method New()
		'Create
		Self.Initialise()
		
		'Set
		_velocity=New Vec2f()
		_acceleration=New Vec2f()
		
		'Self.Scale=New Vec2f(0.5,0.5)
		Self.BlendMode=BlendMode.Additive
		Self.Color=Color.White
	End
	
	Method Reset:Void()
		'Set
		_velocity=New Vec2f
		_acceleration=New Vec2f
		Self.Rotation=0.0
				
		'Re-centre
		Self.ResetPosition(GAME.GameResolution.X/2,GAME.GameResolution.Y/2)
	End
	
	Method Update:Void() Override		
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
			
			'Trail
			Self.State.Trail(Self.X,Self.Y,Self.Rotation-180)
		Endif
		
		'Fire
		If (KeyboardControlHit("FIRE") Or JoystickButtonHit("FIRE"))
			Local bullet:=New BulletEntity(Self.Rotation,New Vec2f(Self.X,Self.Y))
			bullet.State=Self.State
			AddEntity(bullet,LAYER_BULLETS)
			AddEntityToGroup(bullet,"bullets")
			'GAME.PlaySound("bullet")
		Endif
		
		'Update
		_velocity+=_acceleration
		_velocity*=0.99
		Self.Position+=_velocity
		
		'Base
		Super.Update()
	End Method
	
	'Method Render(canvas:Canvas) Override
	'	'Debug
	'	Super.Render(canvas)
	'	canvas.DrawText("Rotation:"+Self.Rotation,0,100)	
	'End Method
	
Private
	Method Initialise()
		'Create ship
		Self.AddPoint(-8,-8)
		Self.AddPoint(12,0)
		Self.AddPoint(-8,8)
		Self.AddPoint(-5,0)
		Self.AddPoint(-8,-8)
	
	End Method
	
End Class
