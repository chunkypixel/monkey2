
Global Particles:=New ParticleManager()

'-----------------------------------------------------------------------------------------------
' Particles usage:
' - Screen Size is based on actual screen size
' - All particles should be plotted within this resolution
' - Particles will be automatically scaled up using the ResolutionScaler
'-----------------------------------------------------------------------------------------------

Enum ParticleType
	Random=0
	Trail=1
	Explosion=2
End Enum

Class ParticleManager

Private
	Field _points:ParticlePoint[]
	Field _index:Int=0
	Field _particleLife:Int=40
	Field _maxParticles:Int=768
Public

	Method New()
		'Initialise
		Self.Initialise()			
	End

	Method CreateParticles:Void(position:Vec2f,type:Int=0,particles:Int=32)
		'Prepare
		Local r:Int=128+Rnd(0,64)
		Local g:Int=r
		Local b:Int=r
		'Create
		Self.CreateParticles(position,type,r,g,b,particles)	
	End

	Method CreateParticles:Void(position:Vec2f,type:Int=0,r:Int,g:Int,b:Int,particles:Int=32)
		'Create
		For Local t:Int=0 Until particles
			Self.Create(position,type,r,g,b)
		Next	
	End
	
	Method CreateTrail:Void(position:Vec2f,direction:Float,particles:Int=2)
		'Validate
		If (direction<0) direction+=360
		If (direction>360) direction-=360
		
		'Offset (from tail)
		Local radian:=DegreesToRadians(direction)
		position.x+=Cos(radian)*8
		position.y+=-Sin(radian)*8
		
		'Create
		For Local t:Int=0 Until particles
			'Prepare
			Local r:Int=128+Rnd(0,64)
			Local g:Int=r
			Local b:Int=r
			'Process
			Self.Create(position,ParticleType.Trail,r,g,b,direction)		
		Next
	End Method
	
	Method CreateExplosion:Void(position:Vec2f,size:Int)
		'Validate
		Local particles:Int
		
		'Validate
		Select size
			Case 1	'Large
				particles=60
			Case 2	'Medium
				particles=40
			Case 3	'Small
				particles=20
		End
		
		'Create
		For Local t:Int=0 Until particles
			'Prepare
			Local r:Int=128+Rnd(0,64)
			Local g:Int=r
			Local b:Int=r
			'Process
			Self.Create(position,ParticleType.Explosion,r,g,b,0.0,size)		
		Next	
	End Method
		
	Method Update:Void()
		'Process
		For Local t:Int=0 To _maxParticles-1
			If (_points[t].active>0) _points[t].Update()
		Next		
	End Method
	
	Method Render(canvas:Canvas)
		'Prepare
		Local r:Float,g:Float,b:Float
			
		'Canvas
		canvas.BlendMode=BlendMode.Additive
		canvas.LineWidth=GetLineWidth(2.0)	'For now make all lines >1.0 for smoothing

		'Get image
		Local image:=GetImage("Particle")
		
		'Process
		For Local t:int=0 To _maxParticles-1
			If (_points[t].active>0)
				'Get color
				r=Min(_points[t].r*1.25,255.0)
				g=Min(_points[t].g*1.25,255.0)
				b=Min(_points[t].b*1.25,255.0)
				
				'Position
				Local v0:=New Vec2f(_points[t].x,_points[t].y)*VirtualResolution.Scale
				Local v1:=New Vec2f(_points[t].x+_points[t].dx,_points[t].y+_points[t].dy)*VirtualResolution.Scale
				
				'Draw (line)
				canvas.Color=GetColor(r,g,b,0.8)	
				canvas.DrawLine(v0,v1)
				
				'Draw (image)
				If (image<>Null) 
					'Sparkle
					Local alpha:Float=0.25
					If (_points[t].active>10) canvas.Alpha=Rnd(0.3,1.0)
					canvas.Color=GetColor(r,g,b,alpha)
					canvas.DrawImage(image,v1,0,New Vec2f(0.75,0.75)*VirtualResolution.Scale)
				End
			End	
		Next
		
		'Reset
		canvas.Color=Color.White	
		canvas.Alpha=1.0
	End Method
	
Private
	Method Create:Void(position:Vec2f,type:Int,r:Int,g:Int,b:Int,direction:Float=0.0,size:Int=2)
		'Prepare
		Local distance:Float
		Local length:Float
		Local range:Float
				
		'Set particle
		_points[_index].x=position.x
		_points[_index].y=position.y
		_points[_index].r=r
		_points[_index].g=g
		_points[_index].b=b
		_points[_index].active=Rnd(_particleLife-20,_particleLife)
		
		'Validate
		Select size
			Case 1
				length=1.8
				range=1.2	
			Case 2
				length=1.4
				range=0.9
			Case 3
				length=1.0
				range=0.6
		End
		
		'Validate
		Select type
			Case ParticleType.Random
				direction=Rnd(0,360)
				distance=Rnd(1.5*range,5.5*range)
				_points[_index].dx=Cos(direction)*distance
				_points[_index].dy=Sin(direction)*distance
			Case ParticleType.Trail
				direction+=Rnd(-1,1)
				distance=1.0
				_points[_index].dx=Cos(direction)
				_points[_index].dy=Sin(direction)
				_points[_index].active/=2
			Case ParticleType.Explosion
				direction=Rnd(0,360)
				distance=Rnd(0.5*range,2.5*range)
				_points[_index].dx=Cos(direction)*distance
				_points[_index].dy=Sin(direction)*distance		
		End
		
		'Finalise
		_points[_index].dx=_points[_index].dx*length
		_points[_index].dy=_points[_index].dy*length
		_points[_index].x+=_points[_index].dx
		_points[_index].y+=_points[_index].dy
		
		'Increment
		_index=(_index+1) Mod _maxParticles		
	End Method

	Method Initialise:Void()
		'Initialise
		_points=New ParticlePoint[_maxParticles]		
		For Local t:Int=0 To _maxParticles-1
			_points[t].Initialise()
		Next	
		
		'Set
		_index=0
	End Method
			
End Class

Struct ParticlePoint
Private
	Field _angle:Float=0.0
public
	Field x:Float=0.0
	Field y:Float=0.0
	Field dx:Float=0.0
	Field dy:Float=0.0
	Field r:Float=0
	Field g:Float=0
	Field b:Float=0
	Field active:Int=0
	Field decay:Float=0.95

	Method Initialise:Void()
		x=0
		y=0
		r=0
		g=0
		b=0
		active=0
		dx=0
		dy=0	
	End Method
	
	Method Update:Void()
		'Update
		x+=dx
		y+=dy
		dx*=decay
		dy*=decay
				
		'Validate
		If (x<-5) x=VirtualResolution.Width+5
		If (x>VirtualResolution.Width+5) x=-5
		If (y<-5) y=VirtualResolution.Height+5
		If (y>VirtualResolution.Height+5) y=-5
		
		'Reduce life
		active-=1
		If (active<20)
			If (active<10)
				r=Max(r*0.8,0.0)
				g=Max(g*0.8,0.0)
				b=Max(b*0.8,0.0)
			Else
				r=Max(r*0.97,0.0)
				g=Max(g*0.97,0.0)
				b=Max(b*0.97,0.0)
			End
		Elseif (active>200)
			'Max
			active=200
		End
		
	End Method

End Struct