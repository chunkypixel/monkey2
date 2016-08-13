
Enum BulletOwner
	Player=0
	UFO=1
End

Class Bullets

	Function Create:Void(owner:BulletOwner,position:Vec2f,rotation:Float)
		'Validate
		'If (Total()>4) Return
		 
		'Create bullet
		Local bullet:=New BulletEntity(owner,position,rotation)
		AddEntity(bullet,LAYER_BULLETS)
		AddEntityToGroup(bullet,"bullets")
		
		'Sound
		PlaySoundEffect("Fire")
	End Function
	
	Function Remove:Void(bullet:BulletEntity)
		RemoveEntity(bullet)
	End Function

	Function Total:Int()
		Local group:=GetEntityGroup("bullets")
		If (group=Null) Return 0 
		Return group.Entities.Count()
	End Function
			
End Class

Class BulletEntity Extends VectorEntity

Private
	Field _active:Int=45
	Field _owner:BulletOwner
Public

	Method New(owner:BulletOwner,position:Vec2f,direction:Float)
		'Create
		Self.Initialise(owner,direction)
		
		'Offset
		If (owner=BulletOwner.Player)
			Local radian:=DegreesToRadians(direction)
			position.X+=Cos(radian)*8
			position.Y+=-Sin(radian)*8
		End
		
		'Position
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

		'Thrust
		Local radian:=DegreesToRadians(Self.Direction)
		Self.X+=Cos(radian)*Self.Speed
		Self.Y+=-Sin(radian)*Self.Speed

		'Collision with objects
		'Note: For some reason collision will not pickup on bullet/player
		Select _owner
			Case BulletOwner.UFO
				If (Player.Visible And Self.CheckCollision(Player))	'Player.CheckCollision(Self)) 
					'Explode (and shake)
					Player.Destroy(2)
				End			
			Case BulletOwner.Player
				If (UFO.Visible And Self.CheckCollision(UFO)) 'UFO.CheckCollision(Self)) 
					'Explode (and shake)
					UFO.Destroy()
				End
		End									
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
	
	Property Owner:BulletOwner()
		Return _owner
	End

	'Note: For some reason collision will not pickup on bullet/player
	Method CheckCollision:Bool(entity:Entity) Override
		'Validate
		If (Not Self.Collision Or Not entity.Collision) Return False
		
		'Prepare
		Local dx:Float=Self.X-entity.X
		Local dy:Float=Self.Y-entity.Y
		Local distance:Float=Sqrt(dx*dx+dy*dy)
		Local radii:Float=(Self.Radius+entity.Radius)
		
		'Validate
		Return Not (radii<distance)
	End Method
		
Private
	Method Initialise:Void(owner:BulletOwner,direction:Float)
		'Points
		Self.CreatePoint(0,0)
		'Self.CreatePoint(0,4)
		'Self.CreatePoint(4,4)
		'Self.CreatePoint(4,0)
		'Self.CreatePoint(0,0)
		
		'Color
		Self.Color=GetColor(224,224,224)

		'Direction
		Self.Direction=direction
		
		'Other
		Self.Speed=9.0
		Self.Collision=True
		Self.Radius=3
		_owner=owner
		
		'Reset
		Self.Reset()	
	End Method
	
End Class
