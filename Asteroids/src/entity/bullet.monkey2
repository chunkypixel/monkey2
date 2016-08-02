
Class BulletEntity Extends VectorEntity

Private
	Field _active:Int=45
Public

	Method New(position:Vec2f,direction:Float)
		'Create
		Self.Initialise()
		
		'Direction
		Self.Direction=direction

		'Position (offset from tip)
		Local radian:=DegreesToRadians(direction)
		position.X+=Cos(radian)*8
		position.Y+=-Sin(radian)*8
		Self.ResetPosition(position.X,position.Y)	
	End Method

	Method Update:Void() Override
		'Base
		If (Not Self.Enabled) Return
		Super.Update()		

		'Remove?
		 _active-=1
		If (_active=0)
			RemoveEntity(Self)
			Return
		End

		'Thrust
		Local radian:=DegreesToRadians(Self.Direction)
		Self.X+=Cos(radian)*Self.Speed
		Self.Y+=-Sin(radian)*Self.Speed
		
		'Collision with rocks?
		Local group:=GetEntityGroup("rocks")
		For Local entity:=Eachin group.Entities
			'Validate
			Local rock:=Cast<RockEntity>(entity)
			If (rock.CheckCollision(Self)) 
				'Explode (and shake)
				Self.State.CreateExplosion(rock.Position)
				Self.State.Shake()
				
				'Score
				Local score:Int=20
				If (rock.Size=RockSize.Medium) score=50
				If (rock.Size=RockSize.Small) score=100
				Self.State.Player.Score+=score
				
				'Split
				Self.State.SplitRock(rock)
				
				'Sound
				PlaySound("Explode2")	'"+Int(Rnd(1,4)))

				'Finalise				
				RemoveEntity(Self)
				Return
			End
		Next			
	End Method
	
	Method Render:Void(canvas:Canvas) Override
		'Base
		Super.Render(canvas)
		
		'Draw (glow)
		Local image:=GetImage("Particle")
		canvas.Alpha=Rnd(0.4,0.8)	'Flicker
		If (image<>Null) canvas.DrawImage(image,Self.Position,0,New Vec2f(0.5,0.5))						
		
		'Reset
		canvas.Alpha=1.0
	End Method

	Method CheckCollision:Bool(entity:Entity) Override
		'Validate
		If (Not Self.Collision) Return False
		Return Self.PointInPolyCollision(Cast<VectorEntity>(entity))
	End Method
	
Private
	Method Initialise()
		'Points
		Self.AddPoint(0,0)
		Self.AddPoint(1,1)
		
		'Other
		Self.Speed=9.0
		'Self.Scale=New Vec2f(1.0,1.0)	
	End Method
	
End Class
