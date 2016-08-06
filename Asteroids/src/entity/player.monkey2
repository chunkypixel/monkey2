
Enum PlayerStateFlags
	Release=1
	Active=2
	Complete=3
	Exploding=4
End

Class PlayerEntity Extends ShipEntity

'NOTES:
' - When ship resets still in direction of last direction - does not reset back up
' - Ship can fire a max of 4 bullets
' - Ship should only be released once there are no rocks within an exclusion zone
' - Ship could fade in with particle effects
Private
	Field _velocity:=New Vec2f
	Field _thrustChannel:Channel
	Field _counterTimer:CounterTimer
	Field _playerState:PlayerStateFlags
	Field _levelComplete:Bool=False
Public
	Field Lives:Int=MAX_LIVES
	Field Score:Int=0
	Field Level:Int=1
	
	Method New()
		'Create
		Self.Initialise()
		
		'Counter
		_counterTimer=New CounterTimer(200,False)
	End
	
	Method Reset:Void() Override
		'Base
		Super.Reset()

		'Set
		Self.Visible=False
		Self.ResetPosition(GAME.GameResolution.X/2,GAME.GameResolution.Y/2)	
		_velocity=New Vec2f()	
				
		'Remove 
		ClearEntityGroup("debris")
	End
	
	Method Update:Void() Override
		'Base
		If (Not Self.Enabled) Return
		Super.Update()		
		
		'Problem! LAST rock is not removed until next cycle
		'we need to identify if active or exploding as each cycles differently
		
		'Level complete?
		If (Not _levelComplete And Self.State.TotalRocks=0) 
			'Sound
			PlaySoundEffect("LevelUp",1.0,2.0)
			Self.State.Thump.Stop()
			
			'Set
			_levelComplete=True
			_counterTimer.Reset()
			
			'Change state?
			If (_playerState=PlayerStateFlags.Active) _playerState=PlayerStateFlags.Complete
		End
		
		'State
		Select _playerState
			Case PlayerStateFlags.Release
				'Prepare
				Local canRelease:Bool=True		 

				'Validate
				Local group:=GetEntityGroup("rocks")
				For Local entity:=Eachin group.Entities
					'Validate (check zone around player)
					If (Self.State.InExclusionZone(entity)) canRelease=False
				Next		
				
				'Can we release?
				If (canRelease) 
					'Set
					_playerState=PlayerStateFlags.Active
					Self.Visible=True
					
					'Display rocks (if required)					
					Local group:=GetEntityGroup("rocks")
					For Local entity:Entity=Eachin group.Entities
						Local rock:=Cast<RockEntity>(entity)
						rock.Enabled=True
					Next
										
					'Remove life
					Self.Lives-=1
					
					'Sound
					PlaySoundEffect("Appear",1.0)
				End
				
			Case PlayerStateFlags.Active				
				'Sound?
				If (Not Self.State.Thump.IsRunning) Self.State.Thump.Start()
				
				'Process
				Self.PlayerMovement()
														
				'Collision with rocks?
				Local group:=GetEntityGroup("rocks")
				For Local entity:=Eachin group.Entities
					'Validate
					Local rock:=Cast<RockEntity>(entity)
					If (rock.CheckCollision(Self)) 
						'Explode (and shake)
						Self.State.CreateExplosion(Self.Position)
						Self.State.CreateShipExplosion(Self.Position)
						Self.State.Shake(10)
						
						'Split
						Self.State.SplitRock(rock)
	
						'Sound
						PlaySoundEffect("Explode1",0.50)
						Self.State.Thump.Stop()
						_thrustChannel.Paused=True
						
						'Set
						_playerState=PlayerStateFlags.Exploding
						Self.Visible=False
						_counterTimer.Reset()
					End
				Next		
				
			Case PlayerStateFlags.Exploding	
				'Game over?
				If (Self.Lives=0) 
					Self.Enabled=False
					Return
				End
					
				
				'Restart?
				If (_counterTimer.Elapsed) 
					'Set
					Self.Reset()
					_playerState=PlayerStateFlags.Release
					
					'Increment level? (may have exploded on last rock) 			
					If (_levelComplete) Self.State.IncrementLevel() 							
					_levelComplete=False
				End
				
			Case PlayerStateFlags.Complete
				'Process
				Self.PlayerMovement()

				'Restart?
				If (_counterTimer.Elapsed) 
					'Set
					_playerState=PlayerStateFlags.Active
					
					'Increment level
					Self.State.IncrementLevel() 			
					_levelComplete=False
				End				
		End
	End Method
		
	'Method Render:Void(canvas:Canvas) Override
	'	Super.Render(canvas)
	'End Method
		
Private
	Method Initialise() Override
		'Base
		Super.Initialise()
		
		'Other
		Self.Speed=0.07
		Self.Rotation=0.0
				
		'Reset
		Self.Reset()
		Self.Enabled=False
		
		'Thrust
		_thrustChannel=PlaySoundEffect("Thrust",0.75,1.0,True)
		_thrustChannel.Paused=True
		
		'State
		_playerState=PlayerStateFlags.Release

	End Method
		
	Method PlayerMovement:Void()
		'This can be used in Active and Complete state
		
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
			acceleration.X=Cos(radian)*Self.Speed*ResolutionScaler.x
			acceleration.Y=-Sin(radian)*Self.Speed*ResolutionScaler.y
			
			'Thrust trail
			Self.State.CreateTrail(Self.Position,Self.Rotation-180)
			
			'Play?
			If (_thrustChannel.Paused) _thrustChannel.Paused=False
		Else
			'Stop?
			 _thrustChannel.Paused=True
		End
		
		'Fire?
		If (KeyboardControlHit("FIRE") Or JoystickButtonHit("FIRE"))
			'Validate
			If (Self.State.TotalBullets<4) 
				'Create bullet
				Local bullet:=New BulletEntity(New Vec2f(Self.X,Self.Y),Self.Rotation)
				bullet.State=Self.State
				AddEntity(bullet,LAYER_BULLETS)
				AddEntityToGroup(bullet,"bullets")
				
				'Sound
				PlaySoundEffect("Fire")
			End
		End
		
		'Position
		_velocity+=acceleration
		_velocity*=0.99
		Self.Position+=_velocity
	End Method
	
End Class
