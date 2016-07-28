
Class BulletEntity Extends VectorEntity

Private
	Field _life:Int=45
	field _thrust:Float=9.0	' 4.5
Public
	Field State:GameState

	Method New(position:Vec2f,direction:Float)
		Self.Initialise()
		'Offset (from tip)
		Local radian:=DegreesToRadians(direction)
		position.X+=Cos(radian)*8
		position.Y+=-Sin(radian)*8
		'Set
		Self.Rotation=direction
		Self.ResetPosition(position.X,position.Y)		
	End Method

	Method Update:Void() Override
		'Validate
		If (Self.X<-5) Self.ResetPosition(GAME.Width+5,Self.Y)
		If (Self.X>GAME.Width+5) Self.ResetPosition(-5,Self.Y)
		If (Self.Y<-5) Self.ResetPosition(Self.X,GAME.Height+5)
		If (Self.Y>GAME.Height+5) Self.ResetPosition(Self.X,-5)

		'Reduce life
		_life-=1
		If (_life=0)
			RemoveEntity(Self)
			Return
		End

		'Thrust
		Local radian:=DegreesToRadians(Self.Rotation)
		Self.X+=Cos(radian)*_thrust
		Self.Y+=-Sin(radian)*_thrust
		
		'Collision with rocks?
		Local group:=GetEntityGroup("rocks")
		For Local entity:=Eachin group.Entities
			'Validate
			Local rock:=Cast<RockEntity>(entity)
			If (rock.CheckCollision(Self)) 
				'Explode (and shake)
				Self.State.CreateExplosion(rock.Position)
				Self.State.Shake()
				
				'Increment
				Self.State.Player.Score+=(50*rock.Size)
				
				'Create new rocks?
				If (rock.Size<ROCK_SMALL)
					For Local i:= 1 To 2
						'Get direction
						Local direction:Int=rock.Direction
						If (i=1) direction-=90
						If (i=2) direction+=90
						
						'Create
						Self.State.CreateRock(rock.Position,rock.Size+1,direction)
					Next
				End
				
				'Remove
				Self.State.RemoveRock(rock)
				RemoveEntity(Self)

				'Exit
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

Private
	Method Initialise()
		'Create
		Self.AddPoint(0,0)
		Self.AddPoint(1,1)
		'Size
		'Self.Scale=New Vec2f(1.0,1.0)
	End Method
	
End Class
