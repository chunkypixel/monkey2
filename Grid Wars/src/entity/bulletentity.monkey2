
Class BulletEntity Extends ImageEntity

Private
	Field _life:Int=45
	field _thrust:Float=9.0	' 4.5
Public
	Field State:GameState

	Method New(position:Vec2f,direction:Float)
		Super.New(BulletImage)
		Self.Rotation=direction
				
		Self.Scale=New Vec2f(0.5,0.5)
		Self.BlendMode=BlendMode.Additive
		Self.Color=Color.White
		
		Self.ResetPosition(position.X, position.Y)
	End Method

	Method Update:Void() Override
		'Validate
		If (Self.X<-5) Self.ResetPosition(GAME.Width+5,Self.Y)
		If (Self.X>GAME.Width+5) Self.ResetPosition(-5,Self.Y)
		If (Self.Y<-5) Self.ResetPosition(Self.X,GAME.Height+5)
		If (Self.Y>GAME.Height+5) Self.ResetPosition(Self.X,-5)

		'Remove?
		_life-=1
		If (_life=0)
			RemoveEntity(Self)
			Return
		End

		'Thrust
		Local radian:=DegreesToRadians(Self.Rotation)
		Self.X+=Cos(radian)*_thrust
		Self.Y+=-Sin(radian)*_thrust
		
		'collision with objects?
		Local group:=GetEntityGroup("rocks")
		For Local entity:=Eachin group.Entities
			'Validate
			Local rock:=Cast<RockEntity>(entity)
			If (rock.CheckCollision(Self)) 
				'Remove bullet
				RemoveEntity(Self)
				
				'Explode
				'Self.State.Shockwave(rock.X,rock.Y)
				Self.State.Explosion(rock.X,rock.Y)
				Self.State.Shake()
				
				'Score
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
				
				'Remove rock
				Self.State.RemoveRock(rock)

				'Exit
				Return
			End
		
		Next
				
	End Method
	
End Class
