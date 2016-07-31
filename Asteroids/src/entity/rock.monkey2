'Size
Enum RockSize
	Big=1
	Medium=2
	Small=3
End

Class RockEntity Extends VectorEntity

Private
	Field _rotationSpeed:Float
Public
	Field Size:Int=0
	
	Method New(position:Vec2f,size:Int,direction:Int,speed:Float=1.0)
		'Create
		Self.Initialise(size,speed)
		
		'Direction
		If (direction<0) direction+=360
		If (direction>360) direction-=360
		Self.Direction=direction
		
		'Position
		Self.ResetPosition(position.X, position.Y)
	End

	Method Update:Void() Override
		'Spin
		Self.Rotation+=_rotationSpeed
		
		'Thrust
		Local radian:=DegreesToRadians(Self.Direction)
		Self.X+=Cos(radian)*Self.Speed
		Self.Y+=-Sin(radian)*Self.Speed

		'Base
		Super.Update()		
	End Method

Private

	Method Initialise:Void(size:Int,speed:Float)
		'Points
		Local type:Int=Rnd(0,4)
		Select type
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
		
		'Speed,Size etc
		Select size
			Case RockSize.Big
				Self.Scale=New Vec2f(1.25,1.25)
				Self.Speed=1.0
			Case RockSize.Medium
				Self.Scale=New Vec2f(0.85,0.85)
				Self.Speed=1.75	
			Default
				'RockSize.Small
				Self.Scale=New Vec2f(0.35,0.35)					
				Self.Speed=2.5
		End Select
		Self.Size=size

		'Other
		_rotationSpeed=Rnd(-3,3)		
		Self.Collision=True
	End Method
		
End Class
