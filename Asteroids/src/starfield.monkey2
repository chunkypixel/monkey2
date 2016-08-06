'http://www.blitzbasic.com/Community/posts.php?topic=96817

Const NumStars:Int=250

Class StarfieldManager
Private
	Field _points:StarfieldPoint[]
	Field _index:Int=0
	Field _speed:Float=0.1
	Field _rotation:Float=0.25
	Field _scale:Float=2.5
Public
	
	Method New()
		Self.Initialise()
	End Method
	
	Method Update:Void()
		'Process
		For Local t:Int=0 To NumStars-1
			_points[t].Update(_speed,_rotation)
		Next		
	End Method
	
	Method Render:Void(canvas:Canvas)
		'Canvas
		canvas.BlendMode=BlendMode.Additive

		'Render
		For Local t:Int=0 To NumStars-1
			If (_points[t].dx>0 Or _points[t].dy>0)
				canvas.Color=GetColor(_points[t].col,_points[t].col,_points[t].col,_points[t].scale)
				canvas.DrawOval(_points[t].dx*ResolutionScaler.x,_points[t].dy*ResolutionScaler.y,
									_scale*_points[t].scale*ResolutionScaler.x,_scale*_points[t].scale*ResolutionScaler.y)
			End
		Next	
		
		'Reset
		canvas.Alpha=1.0	
	End Method
	
	Property Rotation:Float()
		Return _rotation
	Setter(value:Float)
		_rotation=value
	End
	
	Property Speed:Float()
		Return _speed
	Setter(value:Float)
		_speed=value
	End
	
Private
	Method Initialise()
		'Initialise
		_points=New StarfieldPoint[NumStars]			
		
		'Process
		For Local t:Int=0 To NumStars-1
			_points[t].Initialise()
		Next	
	End Method		
End Class

Struct StarfieldPoint
	Field x:Float
	Field y:Float
	Field z:Float
	Field dx:Float
	Field dy:Float
	Field col:Float
	Field vel:Float
	Field scale:Float

	Method Initialise:Void()
		'Set
		x=Rnd(-500,500)
		y=Rnd(-500,500)
		z=Rnd(100,1000)
		dx=0
		dy=0
		vel=Rnd(0.5,5)		
		scale=1.0
	End Method
	
	Method Update:Void(speed:Float,rotation:Float)		
		'Move
		z-=(vel*speed)
		
		'Rotate
		Local radian:=DegreesToRadians(rotation)
		x=x*Cos(radian)-y*Sin(radian)
		y=x*Sin(radian)+y*Cos(radian)
		
		'Color
		col=((255-((z*255)*0.001))*vel)*0.2
		scale=(col/255)

		'Convert 3d into 2d
		dx=((x/z)*100)+(640*0.5)
		dy=((y/z)*100)+(480*0.5)
								
		'Reset?
		If (dx<0 Or dx>640 Or dy<0 Or dy>480 Or z<1) Self.Initialise()		
	End Method
	
End Struct
