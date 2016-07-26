
Class BulletEntity Extends ImageEntity

Private
	Field _life:Int=45
	field _speed:Float=9.0	' 4.5
Public
	Field State:GameState

	Method New(rotation:Float,position:Vec2f)
		Super.New(BulletImage)
		Self.Rotation=rotation
		Self.Radius=4
		
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
		Self.X+=Cos(radian)*_speed
		Self.Y+=-Sin(radian)*_speed

		'collision with objects?
		Local group:=GetEntityGroup("rocks")
		For Local entity:=Eachin group.Entities
			'Validate
			Local rock:=Cast<RockEntity>(entity)
			If (rock.Collision And rock.CheckCollision(Self)) 
				'Remove bullet
				RemoveEntity(Self)
				
				'Explode
				Self.State.Shockwave(rock.X,rock.Y)
				Self.State.Fireworks(rock.X,rock.Y)
			
				'Create new rocks
				For Local i:= 1 To 2
					'Set angle
					Local angle:Int=rock.Angle
					If (i=1) angle-=90
					If (i=2) angle+=90
					
					'Create
					Local newrock:=New RockEntity(rock.Size+1,angle)
					newrock.ResetPosition(rock.X,rock.Y)
					AddEntity(newrock,LAYER_ROCKS)
					AddEntityToGroup(newrock, "rocks")
					'state.rockCount+=1
				Next

				'Remove rock
				RemoveEntity(rock)
				'state.rockCount-=1

				'avoid scanning more rock collisions
				'for this bullet
				Return

			End
		
		Next
				
	End Method
	
End Class
