'Initialise as needed
Global UFO:UFOEntity

Enum UFOSize
	Big=1
	Small=3
End

Const UFO_COUNTERSTART:Int=1250
Const UFO_COUNTERMIN:Int=250

Class UFOEntity Extends VectorEntity
Private
	Field _size:Int
	Field _releaseCounter:CounterTimer
	Field _directionChangeCounter:CounterTimer
	Field _fireCounter:CounterTimer
	Field _directionOffset:Int=0
	Field _directionSteps:Int
	Field _ufoSoundChannel:Channel
	Field _released:Bool=False
Public

	Method New()
		'Timers
		_releaseCounter=New CounterTimer(UFO_COUNTERSTART,False)
		_directionChangeCounter=New CounterTimer(150,False)
		_fireCounter=New CounterTimer(50,False)

		'Initialise
		Self.Initialise()
	End
	
	Property Enabled:Bool() Override
		Return Super.Enabled
	Setter( value:Bool ) Override
		Super.Enabled=value
		If (value) Self.Start()
		If (Not value) Self.Stop()
	End
	
	Method Update:Void() Override
		'Base
		If (Not Self.Enabled) Return
		Super.Update()		
				
		'Counter
		If (Not _releaseCounter.IsRunning) _releaseCounter.Restart() 
		If (_releaseCounter.Elapsed And Not _released) Self.Release()
		If (Not _released) Return

		'Finished?
		If (_directionSteps>0)
			_directionSteps-=1
			If (_directionSteps=0)
				'Reset
				_directionChangeCounter.Restart()
				_directionOffset=0
			End
		End
							
		'Direction?
		If (_directionChangeCounter.Elapsed And _directionSteps=0)
			'Steps
			_directionSteps=Int(Rnd(50,100))

			'Direction
			_directionOffset=-45
			If (Int(Rnd(2))=1)_directionOffset=45
		End
		
		'Fire?
		If (_fireCounter.Elapsed) 
			'Set direction
			'Randon for large, more accurate for small
			Local direction:Float=Rnd(0,360)
			If (_size=UFOSize.Small)
				'Prepare (get more accurate higher the score)
				Local offset:Float=5.0
				If (Player.Score>15000) offset=4.0
				If (Player.Score>25000) offset=3.0
				If (Player.Score>30000) offset=2.0
				If (Player.Score>35000) offset=1.0
				'Get actual angle to ship and offset either side
				direction=Abs(ATan2(Player.Y-Self.Y,Player.X-Self.X)*180/Pi)
				If(Int(Rnd(2))=1) direction-=offset Else direction+=offset
			End
			
			'Create
			Bullets.Create(BulletOwner.UFO,Self.Position,direction)
			_fireCounter.Restart()
		End
		
		'Thrust
		Local radian:=DegreesToRadians(Self.Direction+_directionOffset)
		Self.X+=Cos(radian)*Self.Speed
		Self.Y+=-Sin(radian)*Self.Speed			
	End Method
	
	Method Release:Void()
		'Validate
		Local direction:Float=0
		Local x:Int=-10
		If (Int(Rnd(2))=1) 
			x=VirtualResolution.Width+10
			direction=180
		End
		Local y:Int=Rnd(50,VirtualResolution.Height-50)
		
		'Testing
		'x=-10
		'y=VirtualResolution.Height/2
		'direction=0
		
		'Position and direction
		Self.ResetPosition(x,y)
		Self.Direction=direction
		_directionOffset=0
		
		'Size and speed
		_size=UFOSize.Big
		If (Player.Score>10000) _size=UFOSize.Small
		Select _size
			Case UFOSize.Big
				Self.Scale=New Vec2f(0.8,0.8)
				Self.Speed=1.5
			Case UFOSize.Small
				Self.Scale=New Vec2f(0.5,0.5)
				Self.Speed=2.5
		End	
		Self.Reset()
				
		'Sound (loop)
		Local soundEffect:String="LSaucer"
		If (_size=UFOSize.Small) soundEffect="SSaucer"
		_ufoSoundChannel=PlaySoundEffect(soundEffect,1.0,1.0,True)
		
		'Set
		Self.Visible=True
		_releaseCounter.Stop()	
		_released=True	
		_directionChangeCounter.Restart()
		_fireCounter.Restart()
	End Method
	
	Method Destroy:Void(incrementScore:Bool=True)
		'Destroy
		Particles.CreateExplosion(Self.Position,Self.Size)
		Camera.Shake(5.0)

		'Score?
		If (incrementScore)
			Local score:Int=200
			If (_size=UFOSize.Small) score=1000
			Player.Score+=score
			'Text
			ExplodingText.Create(Self.Position,score)
		End
		
		'Sound
		PlaySoundEffect("Explode1",0.50)
				
		'Finalise
		Self.Stop()
	End Method
	
	Property Size:Int()
		Return _size
	End
	
	Property Released:Bool()
		Return _released
	End
			
Private
	Method Initialise:Void() Virtual
		'Points
		Self.CreatePoint( -5, -3)
		Self.CreatePoint( -3, -7)
		Self.CreatePoint(  3, -7)
		Self.CreatePoint(  5, -3)
		Self.CreatePoint( -5, -3)
		Self.CreatePoint(-12,  0)
		Self.CreatePoint( -5,  4)
		Self.CreatePoint(  5,  4)
		Self.CreatePoint( 12,  0)
		Self.CreatePoint(  5, -3)
		Self.CreatePoint( 12,  0)
		Self.CreatePoint(-12,  0)
					
		'Other
		Self.Color=UFOColor
		Self.Rotation=0.0
		Self.Collision=True
		Self.Radius=7
		Self.Enabled=False
		Self.Visible=False
		
		'Reset
		Self.Reset()
	End Method

	Method Start:Void()
		'Set (delay)
		_releaseCounter.Interval=Max(UFO_COUNTERMIN,UFO_COUNTERSTART-(Player.Level*100)) 
		_releaseCounter.Restart()
	End Method
	
	Method Stop:Void()
		'Set
		Self.Visible=False
		_released=False
		If (_releaseCounter<>Null) _releaseCounter.Stop()		
		If (_directionChangeCounter) _directionChangeCounter.Stop()
		If (_fireCounter<>Null) _fireCounter.Stop()	
		
		'Sound
		If (_ufoSoundChannel<>Null) _ufoSoundChannel.Stop()
	End Method
	
End Class