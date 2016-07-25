
Class Poly
Private
	Field _points:PolyPoint[]
	Field _basePoints:PolyPoint[]
	Field _count:Int=0
	Field _scale:=New Vec2f(1.0,1.0)
	Field _angle:Float=0.0
Public

	Method New(points:Int=20)
		'Initialise
		_points=New PolyPoint[points]	
		_basePoints=New PolyPoint[points]	
	End Method
	
	Method Add(x:Float,y:Float)
		'Set
		_basePoints[_count].x=x
		_basePoints[_count].y=y
		Update()
		
		'Increment
		_count+=1	
	End Method
	
	Method Render:Void(canvas:Canvas,x:Float,y:Float)
		'Canvas
		Local currentTextureFilteringEnabled:Bool=canvas.TextureFilteringEnabled
		canvas.TextureFilteringEnabled=True
		canvas.Alpha=0.3
		canvas.BlendMode=BlendMode.Additive	
		canvas.LineWidth=2.0	'For now make all lines >1.0 for smoothing
		canvas.Color=Color.White
		
		'Prepare
		Local dx:Float=_points[0].x+x
		Local dy:Float=_points[0].y+y
		
		'Draw
		For Local index:Int=1 Until _count
			canvas.DrawLine(dx,dy,_points[index].x+x,_points[index].y+y)
			dx=_points[index].x+x
			dy=_points[index].y+y
		Next
		
		'Reset
		canvas.TextureFilteringEnabled=currentTextureFilteringEnabled
		canvas.Alpha=1.0
		canvas.BlendMode=BlendMode.Alpha
		canvas.LineWidth=1.0
		canvas.Color=Color.White
				
	End Method
	
	Method Scale(sx:Float,sy:Float)
		Self.Scale(New Vec2f(_scale.X*sx,_scale.Y*sy))
	End Method
	
	Method Resize(sx:Float,sy:Float)
		Self.Scale(New Vec2f(sx,sy))
	End Method
		
	Method Rotation(angle:Float)
		_angle=angle
		Update()
	End Method
	
	Method IsColliding:Bool(x1:Float,y1:Float,x2:Float,y2:Float)
		Local j:Int=_count-1
		Local colliding:Bool = False
				
		'Process
		For Local i:Int=0 Until _count
			'Prepare
			Local xI:Float=_points[i].x+x1
			Local yI:Float=_points[i].y+y1
			Local xJ:Float=_points[j].x+x1
			Local yJ:Float=_points[j].y+y1
			
			'Validate
			If (((yI>y2)<>(yJ>y2)) And (x2<(xJ-xI)*(y2-yI)/(yJ-yI)+xI)) 
				colliding=Not colliding
			End

			'If ((((yI<=y2) And (y2<yJ)) Or ((yJ<=y2) And (y2<yI))) And (x2<(xJ-xI)*(y2-yI)/(yJ-yI)+xI)) 
			'	colliding=Not colliding
			'End
			
			'Set
			j=i
		Next
		
		'Return
		Return colliding
	End
	
Private
	Method Scale(scale:Vec2f)
		_scale=scale
		Update()
	End Method

	Method Update:Void()
		For Local index:Int=0 Until _count
			'Prepare
			Local fx:Float=_basePoints[index].x
			Local fy:Float=_basePoints[index].y
			
			'Scale
			fx*=_scale.x
			fy*=_scale.y
			
			'Rotation
			If (_angle<>0.0)
				Local rX:Float=Cos(_angle)*fx-Sin(_angle)*fy
				Local rY:Float=Sin(_angle)*fx+Cos(_angle)*fy
				fx=rX
				fy=rY
			End 
			
			'Finalise
			_points[index].x=fx
			_points[index].y=fy
		Next
	End Method
	
End Class

Struct PolyPoint
	Field x:Float=0.0
	Field y:Float=0.0
End Struct 
