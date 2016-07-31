
Enum PlayerStateFlags
	Release=1
	Active=2
	Exploding=3
End

Class PlayerEntity Extends VectorEntity

'NOTES:
' - When ship resets still in direction of last direction - does not reset back up
' - Ship can fire a max of 4 bullets
' - Ship should only be released once there are no rocks within an exclusion zone
' - Ship could fade in with particle effects
Private
	Field _velocity:=New Vec2f
	Field _thrustChannel:Channel
Public
	Field Lives:Int=3
	Field Score:Int=0
	Field PlayerState:PlayerStateFlags
	
	Method New()
		'Create
		Self.Initialise()
	End
	
	Method Reset:Void() Override
		'Set
		Self.PlayerState=PlayerStateFlags.Release
		Self.Visible=False
		Self.ResetPosition(GAME.GameResolution.X/2,GAME.GameResolution.Y/2)	
		_velocity=New Vec2f()
					
		'Base
		Super.Reset()
	End
	
	Method Update:Void() Override
		'Process?
		If (Self.State.GameState<>GameStateFlags.Play) Return
				
		'State
		Select Self.PlayerState
			Case PlayerStateFlags.Release
				'Prepare
				Local canRelease:Bool=True

				'Validate
				Local group:=GetEntityGroup("rocks")
				For Local entity:=Eachin group.Entities
					'Validate (check zone around player)
					If (Self.InExclusionZone(entity)) canRelease=False
				Next		
				
				'Can we release?
				If (canRelease) 
					Self.PlayerState=PlayerStateFlags.Active
					Self.Visible=True
				End
				
			Case PlayerStateFlags.Active
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
		
				'Thrust?
				Local acceleration:=New Vec2f()
				If (KeyboardControlDown("THRUST") Or JoystickButtonDown("THRUST"))
					'Calculate
					Local radian:=DegreesToRadians(Self.Rotation)
					acceleration.X=Cos(radian)*Self.Speed
					acceleration.Y=-Sin(radian)*Self.Speed
					
					'Thrust trail
					Self.State.CreateTrail(Self.Position,Self.Rotation-180)
					
					'Play sound?
					'If (_thrustChannel=Null Or (_thrustChannel<>Null And Not _thrustChannel.Playing)) _thrustChannel=PlaySound("Thrust",-1)
				Else
					'Stop sound?
					If (_thrustChannel<>Null) _thrustChannel.Stop()
				End
				
				'Fire?
				If (KeyboardControlHit("FIRE") Or JoystickButtonHit("FIRE"))
					'Count
					'Player can fire a max of 4 bullets
					If (Self.State.TotalBullets<4) 
						'Create bullet
						Local bullet:=New BulletEntity(New Vec2f(Self.X,Self.Y),Self.Rotation)
						bullet.State=Self.State
						AddEntity(bullet,LAYER_BULLETS)
						AddEntityToGroup(bullet,"bullets")
						
						'Sound
						Local fireChannel:=PlaySound("Fire")
						fireChannel.Volume=0.25
					End
				End
				
				'Position
				_velocity+=acceleration
				_velocity*=0.99
				Self.Position+=_velocity
				
				'Collision with rocks?
				Local group:=GetEntityGroup("rocks")
				For Local entity:=Eachin group.Entities
					'Validate
					Local rock:=Cast<RockEntity>(entity)
					If (rock.CheckCollision(Self)) 
						'Explode (and shake)
						Self.State.CreateExplosion(Self.Position)
						Self.State.Shake(10)
						
						'Sound
						PlaySound("Explode1")
						
						'Set
						Self.PlayerState=PlayerStateFlags.Exploding
						Self.Lives-=1
						Self.Visible=False
					End
				Next		
			
			Case PlayerStateFlags.Exploding				
				'Finished?
				If (Self.Lives=0) 
					Self.State.GameState=GameStateFlags.GameOver
					Return
				End
				
				'TODO: Validate (timer)
				Self.Reset()
		End
						
		'Base
		Super.Update()
	End Method
		
	Method InExclusionZone:Bool(entity:Entity)
		return (entity.X>Self.X-100 And entity.X<Self.X+100 And entity.Y>Self.Y-100 And entity.Y<Self.Y+100) 		
	End
	
Private
	Method Initialise()
		'Points
		Self.AddPoint(-8,-8)
		Self.AddPoint(12,0)
		Self.AddPoint(-8,8)
		Self.AddPoint(-5,0)
		Self.AddPoint(-8,-8)
			
		'Other
		Self.Speed=0.07
		Self.Scale=New Vec2f(0.75,0.75)
		Self.Rotation=90.0
		
		'Reset
		Self.Reset()
	End Method
	
End Class
