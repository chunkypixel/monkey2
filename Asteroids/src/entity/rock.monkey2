
Enum RockSize
	Big=1
	Medium=2
	Small=3
End

Class Rocks
	Global MaxRocks:Int=4

	'Features (Rocks)
	Function Create:Void(enabled:Bool=False)
		'Prepare
		Local counter:Int=0
	
		'Testing (postion for direct access)
		'CreateRock(New Vec2f(VirtualResolution.Width/2+100,VirtualResolution.Height/2),RockSize.Small,Rnd(360),0.0,enabled)
		'Return
		
		'Process
		Repeat 
			'Get position and validate
			Local position:=New Vec2f(Rnd(40,VirtualResolution.Width-40),Rnd(20,VirtualResolution.Height-20))	
			If (InExclusionZone(position)) Continue
						
			'Speed (increase base speed each level)
			Local speed:Float=0.75+Min(Player.Level*0.1,1.0)
			If (Int(Rnd(0,2)>=1)) speed-=0.35	'Reduce some
			
			'Create (RockSize.Big)
			Create(position,RockSize.Big,Rnd(360),speed,enabled)
			
			'Increment
			counter+=1
		Until (counter=MaxRocks)
	End Function	
	
	Function Create:Void(position:Vec2f,size:Int,direction:Int,speed:Float,enabled:Bool=True)
		Local rock:=New RockEntity(position,size,direction,speed)
		rock.Enabled=enabled
		AddEntity(rock,LAYER_ROCKS,"rocks")
	End Function
		
	Function Split:Void(rock:RockEntity)
		'NOTES: Rocks continue to same general direction
		'       One rock appears to be move faster than other
		'       There can only ever be a max of 26 rocks
					
		'Can split?
		If (rock.Size<RockSize.Small)
			For Local count:Int=1 To 2
				'Validate (allow exiting block to process if at limit)
				If (count>1 And OnScreen()>=26) Continue 
	
				'Direction (seperate) 
				Local direction:Int=rock.Direction
				If (count=1) direction-=Rnd(5,25)
				If (count=2) direction+=Rnd(10,40)
					
				'Speed
				Local speed:Float=rock.Speed+0.50
				If (count=1) speed-=0.25	'Reduce some
					
				'Create
				Create(rock.Position,rock.Size+1,direction,speed)
			Next
		End	
			
		'Remove parent rock
		Remove(rock)
	End Function
		
	Function Remove:Void(rock:RockEntity)
		RemoveEntity(rock)
	End Function
		
	Function OnScreen:Int()
		Local group:=GetEntityGroup("rocks")
		If (group=Null) Return 0 
		Return group.Entities.Count()
	End Function
		
	Function Remaining:Int()
		'Validate
		Local group:=GetEntityGroup("rocks")
		If (group=Null) Return 0 
		
		'Process
		Local count:Int=0
		For Local entity:=Eachin group.Entities
			Local rock:=Cast<RockEntity>(entity)
			Select rock.Size
				Case RockSize.Big
					count+=7
				Case RockSize.Medium
					count+=3
				Case RockSize.Small
					count+=1
			End
		Next
			
		'Result
		Return Min(99,count)
	End Function

End Class

Class RockEntity Extends VectorEntity

Private
	Field _rotationSpeed:Float
	Field _size:Int=0
Public
	
	Method New(position:Vec2f,size:Int,direction:Int,speed:Float)
		'Create
		Self.Initialise(size,direction,speed)	
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
	
	Property Size:Int()
		Return _size
	End
	
Private
	Method Initialise:Void(size:Int,direction:Float,speed:Float)
		'Rock
		Local type:Int=Rnd(0,4)
		Select type
			Case 0
				Self.CreatePoint(-10,0)
				Self.CreatePoint(-19,-5)
				Self.CreatePoint(-5,-19)
				Self.CreatePoint(10,-20)
				Self.CreatePoint(21,-5)
				Self.CreatePoint(21,6)
				Self.CreatePoint(12,20)
				Self.CreatePoint(-1,20)
				Self.CreatePoint(-1,6)
				Self.CreatePoint(-9,20)
				Self.CreatePoint(-20,6)
				Self.CreatePoint(-10,0)			
			Case 1
				Self.CreatePoint(-20,-8)
				Self.CreatePoint(-5,-8)
				Self.CreatePoint(-11,-20)
				Self.CreatePoint(6,-20)
				Self.CreatePoint(21,-8)
				Self.CreatePoint(21,-4)
				Self.CreatePoint(6,0)
				Self.CreatePoint(21,11)
				Self.CreatePoint(10,21)
				Self.CreatePoint(6,15)
				Self.CreatePoint(-10,20)
				Self.CreatePoint(-20,8)
				Self.CreatePoint(-20,-8)							
			Case 2
				Self.CreatePoint(-15,0)
				Self.CreatePoint(-20,-11)
				Self.CreatePoint(-9,-20)
				Self.CreatePoint(1,-14)
				Self.CreatePoint(12,-20)
				Self.CreatePoint(21,-11)
				Self.CreatePoint(11,-5)
				Self.CreatePoint(21,6)
				Self.CreatePoint(12,20)
				Self.CreatePoint(-4,15)
				Self.CreatePoint(-9,20)
				Self.CreatePoint(-20,11)
				Self.CreatePoint(-15,0)							
			Case 3
				Self.CreatePoint(-20,-11)
				Self.CreatePoint(-8,-20)
				Self.CreatePoint(2,-11)
				Self.CreatePoint(12,-20)
				Self.CreatePoint(20,-9)
				Self.CreatePoint(20,-6)
				Self.CreatePoint(16,0)
				Self.CreatePoint(20,12)
				Self.CreatePoint(8,20)
				Self.CreatePoint(-8,20)
				Self.CreatePoint(-20,11)				
				Self.CreatePoint(-20,-11)							
		End Select
		
		'Size
		Select size
			Case RockSize.Big
				Self.Scale=New Vec2f(1.00,1.00)
			Case RockSize.Medium
				Self.Scale=New Vec2f(0.50,0.50)
			Default
				Self.Scale=New Vec2f(0.25,0.25)					
		End Select
		_size=size

		'Direction
		If (direction<0) direction+=360
		If (direction>360) direction-=360
		Self.Direction=direction

		'Other
		Self.Speed=speed
		Self.Collision=True
		_rotationSpeed=Rnd(-2,2)	
		
		'Reset
		Self.Reset()	
	End Method
		
End Class
