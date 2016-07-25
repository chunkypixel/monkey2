
Class RockEntity Extends ImageEntity

Private
	Field _rotationSpeed:Float
	Field _speed:Float
	Field _type:Int=0'Rnd(0,4)
	Field _poly:Poly
Public
	Field Angle:Float
	Field Size:Int=0
	
	Method New(angle:Float)
		Super.New(PlayerImage)
		
		'Validate
		If (angle<0) angle+=360
		If (angle>360) angle-=360
		Self.Angle=angle
		Self.Rotation=Rnd(360)
		Self.Radius=4
		
		'Self.Scale=New Vec2f(0.5,0.5)
		'Self.BlendMode=BlendMode.Additive
		'Self.Color=Color.White
	End

	Method Update:Void() Override
		'Validate
		If (Self.X<-5) Self.ResetPosition(GAME.Width+5,Self.Y)
		If (Self.X>GAME.Width+5) Self.ResetPosition(-5,Self.Y)
		If (Self.Y<-5) Self.ResetPosition(Self.X,GAME.Height+5)
		If (Self.Y>GAME.Height+5) Self.ResetPosition(Self.X,-5)
		
		'Spin
		'DebugStop()
		Self.Rotation+=_rotationSpeed
		_poly.Rotation(Self.Rotation)
		'Print "Rotation:"+Self.Rotation
		
		'Thrust
		Local radian:= DegreesToRadians(Self.Angle)
		Self.X+=Cos(radian)*_speed
		Self.Y+=-Sin(radian)*_speed

	End Method

	Method Render:Void(canvas:Canvas) Override
		_poly.Render(canvas,Self.X,Self.Y)
	End

	Method SetSize:Void(size:Int)
		'Create
		_poly=New Poly()
		_rotationSpeed=Rnd(-0.05,0.05)		
		
		'Set
		Select size
			Case SIZE_BIG
				_speed=1	'Rnd(1,2)*2
				Self.Radius=14
				
				'Create
				_poly.Add(-10,0)
				_poly.Add(-19,-5)
				_poly.Add(-5,-19)
				_poly.Add(10,-20)
				_poly.Add(21,-5)
				_poly.Add(21,6)
				_poly.Add(12,20)
				_poly.Add(-1,20)
				_poly.Add(-1,6)
				_poly.Add(-9,20)
				_poly.Add(-20,6)
				_poly.Add(-10,0)
				_poly.Resize(1.25,1.25)
				
			Case SIZE_MEDIUM
				_speed=2	'Rnd(0.3,0.4)*4
				Self.Radius=8
				
				'Create
				_poly.Add(-20,-8)
				_poly.Add(-5,-8)
				_poly.Add(-11,-20)
				_poly.Add(6,-20)
				_poly.Add(21,-8)
				_poly.Add(21,-4)
				_poly.Add(6,0)
				_poly.Add(21,11)
				_poly.Add(10,21)
				_poly.Add(6,15)
				_poly.Add(-10,20)
				_poly.Add(-20,8)
				_poly.Add(-20,-8)				
				'_poly.Resize(1.25,1.25)

			Case SIZE_SMALL
				_speed=3	'Rnd(0.5,0.7)*6
				Self.Radius=4
				
				'Create
				_poly.Add(-15,0)
				_poly.Add(-20,-11)
				_poly.Add(-9,-20)
				_poly.Add(1,-14)
				_poly.Add(12,-20)
				_poly.Add(21,-11)
				_poly.Add(11,-5)
				_poly.Add(21,6)
				_poly.Add(12,20)
				_poly.Add(-4,15)
				_poly.Add(-9,20)
				_poly.Add(-20,11)
				_poly.Add(-14,0)				
				'_poly.Resize(0.5,0.5)
				
			Default
				_speed=4	'Rnd(0.5,0.7)*6
				Self.Radius=4
				
				'Create
				_poly.Add(-20,-11)
				_poly.Add(-8,-20)
				_poly.Add(2,-11)
				_poly.Add(12,-20)
				_poly.Add(20,-9)
				_poly.Add(20,-6)
				_poly.Add(16,0)
				_poly.Add(20,12)
				_poly.Add(8,20)
				_poly.Add(-8,20)
				_poly.Add(-20,11)				
				_poly.Add(-20,-11)				
				'_poly.Resize(0.25,0.25)
			
		End Select

		'Update
		_poly.Rotation(Self.Rotation)
		Self.Size=size
		
	End Method
		
	Method IsColliding:Bool(x:Float,y:Float)
		Return _poly.IsColliding(Self.X,Self.Y,x,y)
	End
End Class
