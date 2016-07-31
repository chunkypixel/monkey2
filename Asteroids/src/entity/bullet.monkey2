
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
		'Remove?
		 _active-=1
		If (_active=0)
			RemoveEntity(Self)
			Return
		End

		'Validate
		If (Self.X<-5) Self.ResetPosition(GAME.Width+5,Self.Y)
		If (Self.X>GAME.Width+5) Self.ResetPosition(-5,Self.Y)
		If (Self.Y<-5) Self.ResetPosition(Self.X,GAME.Height+5)
		If (Self.Y>GAME.Height+5) Self.ResetPosition(Self.X,-5)

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
				PlaySound("Explode"+Int(Rnd(1,4)))
				
				'Score
				Local score:Int=20
				If (rock.Size=RockSize.Medium) score=50
				If (rock.Size=RockSize.Small) score=100
				Self.State.Player.Score+=score
				
				'Split
				Self.State.SplitRock(rock)
				
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
		canvas.Alpha=0.25
		If (image<>Null) canvas.DrawImage(image,Self.X,Self.Y)						
		
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
		
		'Speed
		Self.Speed=9.0

		'Size
		'Self.Scale=New Vec2f(1.0,1.0)	
	End Method
	
End Class
