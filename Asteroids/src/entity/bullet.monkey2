
Class Bullets

	Function TotalBullets:Int()
		Local group:=GetEntityGroup("bullets")
		If (group=Null) Return 0 
		Return group.Entities.Count()
	End Function
	
	Function Create:Void(owner:ObjectEntity,position:Vec2f,rotation:Float)
		'Validate
		If (TotalBullets()<4) 
			'Create bullet
			Local bullet:=New BulletEntity(owner,position,rotation)
			AddEntity(bullet,LAYER_BULLETS)
			AddEntityToGroup(bullet,"bullets")
			
			'Sound
			PlaySoundEffect("Fire")
		End
	End Function
	
	Function Remove(bullet:BulletEntity)
		RemoveEntity(bullet)
	End Function
	
End Class

Class BulletEntity Extends VectorEntity

Private
	Field _active:Int=45
	Field _owner:ObjectEntity
Public

	Method New(owner:ObjectEntity,position:Vec2f,direction:Float)
		'Create
		Self.Initialise(owner,direction)
		
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
			Bullets.Remove(Self)
			Return
		End

		'Prepare
		Local state:GameState=Cast<GameState>(GAME.GetState(GAME_STATE))

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
				Particles.CreateExplosion(rock.Position,rock.Size)
				Camera.Shake(2.0)
				
				'Score
				Local score:Int=20
				If (rock.Size=RockSize.Medium) score=50
				If (rock.Size=RockSize.Small) score=100
				Player.Score+=score
				
				'Split
				Rocks.Split(rock)
				
				'Sound
				PlaySoundEffect("Explode"+Int(Rnd(1,4)))

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
		If (image<>Null) 
			canvas.Color=Self.Color
			canvas.Alpha=GetAlpha()	'Flicker
			canvas.DrawImage(image,Self.Position*VirtualResolution.Scale,0,New Vec2f(0.35,0.35)*VirtualResolution.Scale)						
		End
		
		'Reset
		canvas.Color=Color.White
		canvas.Alpha=1.0
	End Method

	Method CheckCollision:Bool(entity:Entity) Override
		'Validate
		If (Not Self.Collision) Return False
		Return Self.PointInPolyCollision(Cast<VectorEntity>(entity))
	End Method
	
Private
	Method Initialise:Void(owner:ObjectEntity,direction:Float)
		'Points
		Self.CreatePoint(0,0)
		Self.CreatePoint(1,1)
		
		'Color
		Self.Color=GetColor(224,224,224)

		'Direction
		Self.Direction=direction
		
		'Other
		Self.Speed=9.0
		_owner=owner
		
		'Reset
		Self.Reset()	
	End Method
	
End Class
