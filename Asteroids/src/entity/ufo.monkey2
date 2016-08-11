'Initialise as needed
Global UFO:UFOEntity

Enum UFOSize
	Big=1
	Small=3
End

Const UFO_COUNTERSTART:Int=1500
Const UFO_COUNTERMIN:Int=500

Class UFOEntity Extends VectorEntity
Private
	Field _size:Int
	Field _counter:CounterTimer
	Field _ufoSoundChannel:Channel
	Field _released:Bool=False
Public

	Method New()
		'Initialise
		Self.Initialise()
		_counter=New CounterTimer(UFO_COUNTERSTART,False)
	End
	
	Method Update:Void() Override
		'Base
		If (Not Self.Enabled) Return
		Super.Update()		

		'Validate
		If (Not _counter.IsRunning) _counter.Start() 
		If (_counter.Elapsed And Not _released) Self.Release()
		If (Not _released) Return
					
		'Thrust
		Local radian:=DegreesToRadians(Self.Direction)
		Self.X+=Cos(radian)*Self.Speed
		Self.Y+=-Sin(radian)*Self.Speed	
	End Method
	
	Method Release:Void()
		'Prepare
		Local direction:Float=0
		Local x:Int=-10
		Local y:Int=50

		'Size
		_size=UFOSize.Big
		If (Player.Score>10000) _size=UFOSize.Small
								
		'Position and direction
		If (Int(Rnd(2))=1) 
			x=VirtualResolution.Width+10
			direction=0
		End
		If (Int(Rnd(2))=1) 
			y=VirtualResolution.Height-50
			direction=180
		End
		Self.ResetPosition(x,y)
		Self.Direction=direction

		'Size and speed
		Select _size
			Case UFOSize.Big
				Self.Scale=New Vec2f(1.0,1.0)
				Self.Speed=1.5
			Case UFOSize.Small
				Self.Scale=New Vec2f(0.5,0.5)
				Self.Speed=2.25
		End	
		Self.Reset()
				
		'Sound (loop)
		Local soundEffect:String="LSaucer"
		If (_size=UFOSize.Small) soundEffect="SSaucer"
		_ufoSoundChannel=PlaySoundEffect(soundEffect,1.0,1.0,True)
		
		'Set
		Self.Visible=True
		_counter.Stop()	
		_released=True	
	End Method
	
	Method Destroy:Void()
		'Destroy
		Particles.CreateExplosion(Self.Position,Self.Size)
		'Debris.Create(Self.Position)
		Camera.Shake(5.0)

		'Score
		Local score:Int=200
		If (_size=UFOSize.Small) score=1000
		Player.Score+=score

		'Sound
		PlaySoundEffect("Explode1",0.50)
		If (_ufoSoundChannel<>Null) _ufoSoundChannel.Stop()
		
		'Set
		Self.Visible=False
		_counter.Restart()		
		_released=False
	End Method
	
	Method CheckCollision:Bool(entity:Entity) Override
		'Validate
		If (Not Self.Collision) Return False
		Return Self.PointInPolyCollision(Cast<VectorEntity>(entity))
	End Method
	
	Method Restart:Void()
		'Reduce UFO releases each level
		_counter.Interval=Max(UFO_COUNTERMIN,UFO_COUNTERSTART-(Player.Level*100)) 
		_counter.Restart()
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
		Self.Rotation=0.0
		Self.Collision=True
		Self.Enabled=False
		Self.Visible=False
		
		'Reset
		Self.Reset()
	End Method

End Class