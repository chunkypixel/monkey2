
Class RockEntity Extends VectorEntity

Private
	Field _rotationSpeed:Float
	Field _speed:Float
Public
	Field Size:Int=0
	
	Method New(size:Int,angle:Int)
		'Create
		Self.Initialise(size)
		
		'Validate
		If (angle<0) angle+=360
		If (angle>360) angle-=360
		
		'Set
		Self.Angle=angle
		Self.Rotation=Rnd(360)
	End

	Method Update:Void() Override
		'Spin
		Self.Rotation+=_rotationSpeed
		
		'Thrust
		Local radian:=DegreesToRadians(Self.Angle)
		Self.X+=Cos(radian)*_speed
		Self.Y+=-Sin(radian)*_speed

		'Base
		Super.Update()		
	End Method

Private

	Method Initialise:Void(size:Int)
		'Create rock (random)
		Local rockType:Int=Rnd(0,4)
		Select rockType
			Case 0
				Self.AddPoint(-10,0)
				Self.AddPoint(-19,-5)
				Self.AddPoint(-5,-19)
				Self.AddPoint(10,-20)
				Self.AddPoint(21,-5)
				Self.AddPoint(21,6)
				Self.AddPoint(12,20)
				Self.AddPoint(-1,20)
				Self.AddPoint(-1,6)
				Self.AddPoint(-9,20)
				Self.AddPoint(-20,6)
				Self.AddPoint(-10,0)
			
			Case 1
				Self.AddPoint(-20,-8)
				Self.AddPoint(-5,-8)
				Self.AddPoint(-11,-20)
				Self.AddPoint(6,-20)
				Self.AddPoint(21,-8)
				Self.AddPoint(21,-4)
				Self.AddPoint(6,0)
				Self.AddPoint(21,11)
				Self.AddPoint(10,21)
				Self.AddPoint(6,15)
				Self.AddPoint(-10,20)
				Self.AddPoint(-20,8)
				Self.AddPoint(-20,-8)				
			
			Case 2
				Self.AddPoint(-15,0)
				Self.AddPoint(-20,-11)
				Self.AddPoint(-9,-20)
				Self.AddPoint(1,-14)
				Self.AddPoint(12,-20)
				Self.AddPoint(21,-11)
				Self.AddPoint(11,-5)
				Self.AddPoint(21,6)
				Self.AddPoint(12,20)
				Self.AddPoint(-4,15)
				Self.AddPoint(-9,20)
				Self.AddPoint(-20,11)
				Self.AddPoint(-14,0)				
			
			Case 3
				Self.AddPoint(-20,-11)
				Self.AddPoint(-8,-20)
				Self.AddPoint(2,-11)
				Self.AddPoint(12,-20)
				Self.AddPoint(20,-9)
				Self.AddPoint(20,-6)
				Self.AddPoint(16,0)
				Self.AddPoint(20,12)
				Self.AddPoint(8,20)
				Self.AddPoint(-8,20)
				Self.AddPoint(-20,11)				
				Self.AddPoint(-20,-11)				
			
		End Select
		
		'Validate
		Select size
			Case SIZE_BIG
				_speed=1.0
				Self.Scale=New Vec2f(1.25,1.25)
			Case SIZE_MEDIUM
				_speed=1.5	
				Self.Scale=New Vec2f(0.85,0.85)
			Default
				'SIZE_SMALL
				_speed=2.0
				Self.Scale=New Vec2f(0.5,0.5)					
		End Select

		'Color
		Local r:Int=Rnd(0,4)*64
		Local g:Int=Rnd(0,4)*64
		Local b:Int=Rnd(0,4)*64
		Self.Color=GetColor(r,g,b)
		
		'Set
		_rotationSpeed=Rnd(-3,3)		
		Self.Size=size
		
	End Method
		
End Class
