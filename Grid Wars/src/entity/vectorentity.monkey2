
Class VectorEntity Extends ObjectEntity
Private
	Field _renderPoints:VectorPoint[]
	Field _basePoints:VectorPoint[]
	Field _points:Int=0
	Field _currentScale:Vec2f
	Field _currentRotation:Float
Public
	Method New()
		'Initialise
		_renderPoints=New VectorPoint[20]	
		_basePoints=New VectorPoint[20]	
		Self.BlendMode=BlendMode.Additive
	End Method
	
	Method AddPoint(x:Float,y:Float)
		'Set
		_basePoints[_points].x=x
		_basePoints[_points].y=y
		_points+=1	
		
		'Prepare for display
		Self.RenderPoints()
	End Method
	
	Method Update:Void() Override
		'Validate
		If (Self.X<-5) Self.ResetPosition(GAME.Width+5,Self.Y)
		If (Self.X>GAME.Width+5) Self.ResetPosition(-5,Self.Y)
		If (Self.Y<-5) Self.ResetPosition(Self.X,GAME.Height+5)
		If (Self.Y>GAME.Height+5) Self.ResetPosition(Self.X,-5)

		'Validate
		If (_currentScale.X<>Self.Scale.X Or _currentScale.Y<>Self.Scale.Y Or _currentRotation<>Self.Rotation)
			'Update
			Self.RenderPoints()
								
			'Store
			_currentScale=Self.Scale
			_currentRotation=Self.Rotation
		End
		
	End Method
	
	Method Render:Void(canvas:Canvas) Override
		'Canvas
		Local currentTextureFilteringEnabled:Bool=canvas.TextureFilteringEnabled
		canvas.TextureFilteringEnabled=True
		canvas.BlendMode=Self.BlendMode	
		canvas.LineWidth=2.0	'For now make all lines >1.0 for smoothing
		canvas.Color=Self.Color
		
		'Prepare
		Local dx:Float=_renderPoints[0].x+Self.X
		Local dy:Float=_renderPoints[0].y+Self.Y
		
		'Draw
		For Local index:Int=1 Until _points
			canvas.DrawLine(dx,dy,_renderPoints[index].x+Self.X,_renderPoints[index].y+Self.Y)
			dx=_renderPoints[index].x+Self.X
			dy=_renderPoints[index].y+Self.Y
		Next
		
		'Reset
		canvas.TextureFilteringEnabled=currentTextureFilteringEnabled
		canvas.LineWidth=1.0
		canvas.Color=Color.White
	End Method
	
	Method CheckCollision:Bool(entity:Entity) Override
		Local j:Int=_points-1
		Local isColliding:Bool = False
				
		'Process
		For Local i:Int=0 Until _points
			'Prepare
			Local xI:Float=_renderPoints[i].x+Self.X
			Local yI:Float=_renderPoints[i].y+Self.Y
			Local xJ:Float=_renderPoints[j].x+Self.X
			Local yJ:Float=_renderPoints[j].y+Self.Y
			
			'Validate
			'https://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html
			If (((yI>entity.Y)<>(yJ>entity.Y)) And (entity.X<(xJ-xI)*(entity.Y-yI)/(yJ-yI)+xI)) 
				isColliding=Not isColliding
			End
			'If ((((yI<=entity.Y) And (entity.Y<yJ)) Or ((yJ<=entity.Y) And (entity.Y<yI))) And (entity.X<(xJ-xI)*(entity.Y-yI)/(yJ-yI)+xI)) 
			'	isColliding=Not isColliding
			'End
			
			'Store
			j=i
		Next
		
		'Return
		Return isColliding	
	End Method
	
Private
	Method RenderPoints()
		'Process
		For Local index:Int=0 Until _points
			'Prepare
			Local fx:Float=_basePoints[index].x
			Local fy:Float=_basePoints[index].y
			
			'Scale
			fx*=Self.Scale.x
			fy*=Self.Scale.y
			
			'Rotation
			If (Self.Rotation<>0.0)
				Local radian:=DegreesToRadians(-Self.Rotation)
				Local rX:Float=Cos(radian)*fx-Sin(radian)*fy
				Local rY:Float=Sin(radian)*fx+Cos(radian)*fy
				fx=rX
				fy=rY
			End 
			
			'Finalise
			_renderPoints[index].x=fx
			_renderPoints[index].y=fy
		Next
	End Method
	
End Class

Struct VectorPoint
	Field x:Float=0.0
	Field y:Float=0.0
End Struct 