
Class Debris
	
	Function Create:Void(position:Vec2f)
		For Local count:Int = 0 Until 10
			Local debris:=New DebrisEntity(position,Rnd(0,360))
			AddEntity(debris,LAYER_OTHER,"debris")
		Next		
	End Function
	
	Function Remove:Void()
		ClearEntityGroup("debris")	
	End Function

End Class

Class DebrisEntity Extends VectorEntity
Private
	Field _rotationSpeed:Float
Public	
	Method New(position:Vec2f,direction:Float)
		Self.Initialise(direction)	
		'Position
		Self.ResetPosition(position.X, position.Y)
	End

	Method Update:Void() Override
		'Base
		If (Not Self.Enabled) Return
		Super.Update()		
		
		'Spin
		Self.Rotation+=_rotationSpeed
		
		'Thrust
		Local radian:=DegreesToRadians(Self.Direction)
		Self.X+=Cos(radian)*Self.Speed
		Self.Y+=-Sin(radian)*Self.Speed	
	End Method
	
Private
	Method Initialise:Void(direction:Float)
		'Points
		Self.CreatePoint(0,0)
		Self.CreatePoint(1,Int(Rnd(4,10)))
		
		'Other
		Self.Color=DebrisColor
		Self.Speed=Rnd(0.5,1.25)
		Self.Direction=direction
		Self.Collision=False
		_rotationSpeed=Rnd(-4,Rnd(4,10))
		'Self.Scale=New Vec2f(1.0,1.0)	
	End Method
	
End Class
