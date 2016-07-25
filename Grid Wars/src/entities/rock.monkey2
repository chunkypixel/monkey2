
Class RockEntity Extends ImageEntity

Private
	Field _rotationSpeed:Float
	Field _speed:Float
	Field _directionAngle:Float
	Field _type:Int=0'Rnd(0,4)
Public

	Method New(directionAngle:Float)
		Super.New(PlayerImage)
		
		'Validate
		If (directionAngle<0) directionAngle+=360
		If (directionAngle>360) directionAngle-=360
		_directionAngle=directionAngle
		Self.Rotation=Rnd(360)
		Self.Radius=4
		
		Self.Scale=New Vec2f(0.5,0.5)
		Self.BlendMode=BlendMode.Additive
		Self.Color=Color.White
	End

	Method Update:Void() Override
		'Validate
		If (Self.X<-5) Self.ResetPosition(GAME.Width+5,Self.Y)
		If (Self.X>GAME.Width+5) Self.ResetPosition(-5,Self.Y)
		If (Self.Y<-5) Self.ResetPosition(Self.X,GAME.Height+5)
		If (Self.Y>GAME.Height+5) Self.ResetPosition(Self.X,-5)
		
		'Spin
		Self.Rotation+=_rotationSpeed
		
		'Thrust
		Local radian:= DegreesToRadians(_directionAngle)
		Self.X+=Cos(radian)*_speed
		Self.Y+=-Sin(radian)*_speed

	End Method

	Method Render:Void(canvas:Canvas) Override
		
		'Canvas
		Local currentTextureFilteringEnabled:Bool=canvas.TextureFilteringEnabled
		canvas.TextureFilteringEnabled=True
		'canvas.Alpha=Self.Alpha
		canvas.BlendMode=BlendMode.Additive	
		canvas.LineWidth=2.0	'For now make all lines >1.0 for smoothing
		canvas.Color=Color.White
		
		'Create
		Select _type
			Case 0
	    		Local xy:=New Float[24]
				xy[0]=Self.X+-10
				xy[1]=Self.Y+0
				xy[2]=Self.X+-19
				xy[3]=Self.Y+-5
				xy[4]=Self.X+-5
				xy[5]=Self.Y+-19
				xy[6]=Self.X+10
				xy[7]=Self.Y+-20
				xy[8]=Self.X+21
				xy[9]=Self.Y+-5
				xy[10]=Self.X+21
				xy[11]=Self.Y+6
				xy[12]=Self.X+12
				xy[13]=Self.Y+20
				xy[14]=Self.X+-1
				xy[15]=Self.Y+20
				xy[16]=Self.X+-1
				xy[17]=Self.Y+20
				xy[18]=Self.X+-9
				xy[19]=Self.Y+20
				xy[20]=Self.X+-20
				xy[21]=Self.Y+6
				xy[22]=Self.X+-10
				xy[23]=Self.Y+0
				'Draw
				'canvas.Rotate(Self.Rotation)
				canvas.DrawPoly(xy)
				'canvas.Rotate(0)
		End Select
		
		'Reset
		canvas.TextureFilteringEnabled=currentTextureFilteringEnabled
		canvas.Alpha=1.0
		canvas.BlendMode=BlendMode.Alpha
		canvas.LineWidth=1.0
		canvas.Color=Color.White
		
	End


	Method SetSize:Void(size:Int)
		'Self.Frame = size
		Select size
			Case SIZE_BIG
				_speed=Rnd(0.1,0.2)*2
				Self.Radius=14
			Case SIZE_MEDIUM
				_speed=Rnd(0.3,0.4)*4
				_rotationSpeed=Rnd(-1,1)
				Self.Radius=8
			Case SIZE_SMALL
				_speed=Rnd(0.5,0.7)*6
				_rotationSpeed=Rnd(-2,2)
				Self.Radius=4
		End Select
		
	End Method
		
End Class
