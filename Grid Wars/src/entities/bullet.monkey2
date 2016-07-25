
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
			Self.State.Shockwave(Self.X,Self.Y)
			Self.State.Fireworks(Self.X,Self.Y)
			Return
		End

		'Thrust
		Local radian:=DegreesToRadians(Rotation)
		Self.X+=Cos(radian)*_speed
		Self.Y+=-Sin(radian)*_speed

		'collision with objects?

	End Method
	
End Class
