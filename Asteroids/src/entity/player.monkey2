
Class PlayerEntity Extends VectorEntity

Private
	Field _velocity:=New Vec2f
	Field _thrust:Float=0.07
	Field _immune:Bool=False
	Field _immunePause:Int
	Field _immuneFlashPause:Int=7
	Field _dead:Bool=False
	Field _deadPause:Int
Public
	Field State:GameState
	Field Lives:Int=3
	Field Score:Int=0
	
	Method New()
		'Create
		Self.Initialise()
	End
	
	Method Reset:Void() Override
		'Position
		_velocity=New Vec2f()
		Self.Rotation=90.0
		Self.ResetPosition(GAME.GameResolution.X/2,GAME.GameResolution.Y/2)		
		'General
		_immune=True
		_immunePause=98
		'Base
		Super.Reset()
	End
	
	Method Update:Void() Override
		'Is Dead?
		If (_dead)
			'Validate
			_deadPause-=1
			If (_deadPause=0)
				If (Self.Lives>0)
					'Restart
					_dead=False
					Self.Reset()
					Self.Visible=True
				Else
					'End
					Self.State.EndGame()
				End
			End		
			'Exit
			Return
		End

		'Is Immume?	
		If (_immune)
			'Flash?
			If (_immunePause Mod _immuneFlashPause=0) Self.Visible=Not Self.Visible
			'Validate
			_immunePause-=1
			If (_immunePause=0)
				_immune=False
				Self.Visible=True
			End
		End
		
		'Rotation
		If (KeyboardControlDown("LEFT")) Self.Rotation+=3
		If (KeyboardControlDown("RIGHT")) Self.Rotation-=3
		' analogue rotation. more is faster turn
		' a little deadzone of 0.1
		local value:Float=JoystickAxisValue("TURN")
		If (value<-0.2) Self.Rotation+=4*Abs(value)
		If (value>0.2) Self.Rotation-=4*value
		' check joy hat
		' if there is no hat, the value of 0 is returned
		' so it can be called without problem
		Local hatValue:JoystickHat=JoystickHatValue(0)
		If (hatValue=JoystickHat.Left) Self.Rotation+=3
		If (hatValue=JoystickHat.Right) Self.Rotation-=3
		'Validate
		If (Self.Rotation<0) Self.Rotation+=360
		If (Self.Rotation>360) Self.Rotation-=360

		'Thrust
		Local acceleration:=New Vec2f()
		If (KeyboardControlDown("THRUST") Or JoystickButtonDown("THRUST"))
			'Calculate
			Local radian:=DegreesToRadians(Self.Rotation)
			acceleration.X=Cos(radian)*_thrust
			acceleration.Y=-Sin(radian)*_thrust	
			
			'Trail
			Self.State.CreateTrail(Self.Position,Self.Rotation-180)
		End
		
		'Fire
		If (KeyboardControlHit("FIRE") Or JoystickButtonHit("FIRE"))
			Local bullet:=New BulletEntity(New Vec2f(Self.X,Self.Y),Self.Rotation)
			bullet.State=Self.State
			AddEntity(bullet,LAYER_BULLETS)
			AddEntityToGroup(bullet,"bullets")
			'GAME.PlaySound("bullet")
		End
		
		'Update
		_velocity+=acceleration
		_velocity*=0.99
		Self.Position+=_velocity
		
		'Collision
		If (Not _immune) 
			'Collision with rocks?
			Local group:=GetEntityGroup("rocks")
			For Local entity:=Eachin group.Entities
				'Validate
				Local rock:=Cast<RockEntity>(entity)
				If (rock.CheckCollision(Self)) 
					'Explode (and shake)
					Self.State.CreateExplosion(Self.Position)
					Self.State.Shake(10)
					'Set
					_dead=true
					_deadPause=100
					Self.Lives-=1
					Self.Visible=False
				End
			Next		
		End
		
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
		'Create
		Self.AddPoint(-8,-8)
		Self.AddPoint(12,0)
		Self.AddPoint(-8,8)
		Self.AddPoint(-5,0)
		Self.AddPoint(-8,-8)
		'Size
		Self.Scale=New Vec2f(0.75,0.75)
	End Method
	
End Class
