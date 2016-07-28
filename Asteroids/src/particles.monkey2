
Enum ParticleType
	Random=0
	Trail=1
	Explosion=2
End Enum

Const NumParticles:Int=1024
Const ParticleLife:Int=40

Class ParticleManager

Private
	Field _points:ParticlePoint[]
	Field _index:Int=0
Public
	Field Alpha:Float=1.0
	
	Method New()
		'Initialise
		_points=New ParticlePoint[NumParticles]		
		Self.Reset()			
	End
	
	Method CreateParticles:Void(x:Int,y:Int,type:Int=0,particles:Int=32)
		'Prepare
		Local r:Int=Rnd(0,4)*64
		Local g:Int=Rnd(0,4)*64
		Local b:Int=Rnd(0,4)*64

		'Create
		Self.CreateParticles(x,y,type,r,g,b,particles)	
	End

	Method CreateParticles:Void(x:Int,y:Int,type:Int=0,r:Int,g:Int,b:Int,particles:Int=32)
		'Create
		For Local t:Int=0 Until particles
			Self.Create(x,y,type,r,g,b)
		Next	
	End
	
	Method CreateTrail:Void(x:Int,y:Int,direction:Float,particles:Int=2)
		'Validate
		If (direction<0) direction+=360
		If (direction>360) direction-=360
		
		'Offset (from tail)
		Local radian:=DegreesToRadians(direction)
		x+=Cos(radian)*8
		y+=-Sin(radian)*8
		
		'Create
		For Local t:Int=0 Until particles
			'Prepare
			'Orange/Yellow
			'Local r:Int=255-Rnd(0,32)
			'Local g:Int=64+Rnd(0,128)
			'Local b:Int=0
			'Grey
			Local r:Int=128+Rnd(0,64)
			Local g:Int=r
			Local b:Int=r
			'Process
			Self.Create(x,y,ParticleType.Trail,r,g,b,direction)		
		Next
	End Method
	
	Method CreateExplosion:Void(x:Int,y:Int)
		'Create
		For Local t:Int=0 Until 32
			'Prepare
			Local r:Int=128+Rnd(0,64)
			Local g:Int=r
			Local b:Int=r
			'Process
			Self.Create(x,y,ParticleType.Explosion,r,g,b)		
		Next	
	End Method
	
	Method Update:Void()
		'Process
		For Local t:Int=0 To NumParticles-1
			If (_points[t].active>0) _points[t].Update()
		Next		
	End Method
	
	Method Reset:Void()
		'Reset
		_index=0
		For Local t:Int=0 To NumParticles-1
			_points[t].x=0
			_points[t].y=0
			_points[t].r=0
			_points[t].g=0
			_points[t].b=0
			_points[t].active=0
			_points[t].dx=0
			_points[t].dy=0
		Next		
	End Method
	
	Method Render(canvas:Canvas)
		Local r:Float,g:Float,b:Float
			
		'Prepare
		'Local currentTextureFilteringEnabled:Bool=canvas.TextureFilteringEnabled
		'canvas.TextureFilteringEnabled=True
		'canvas.BlendMode=BlendMode.Additive
		canvas.LineWidth=2.0	'For now make all lines >1.0 for smoothing
		
		'Get image
		Local image:=GetImage("Particle")
		
		'Process
		For Local t:int=0 To NumParticles-1
			If (_points[t].active>0)
				'Get color
				r=Min(_points[t].r*1.25,255.0)
				g=Min(_points[t].g*1.25,255.0)
				b=Min(_points[t].b*1.25,255.0)
				canvas.Color=GetColor(r,g,b)
				
				'Draw (line)
				canvas.LineWidth=2.0
				canvas.Alpha=Self.Alpha-0.2	'0.8
				canvas.DrawLine(_points[t].x,_points[t].y,_points[t].x+_points[t].dx,_points[t].y+_points[t].dy)				
				'Draw (image)
				canvas.Alpha=0.25
				If (image<>Null) canvas.DrawImage(image,_points[t].x+_points[t].dx*1.0,_points[t].y+_points[t].dy*1.0)						
			End	
		Next
		
		'Reset
		canvas.Alpha=1.0
		canvas.Color=Color.White	
		'canvas.TextureFilteringEnabled=currentTextureFilteringEnabled
		'canvas.LineWidth=1.0
	End Method
	
Private
	Method Create:Void(x:Float,y:Float,type:Int,r:Int,g:Int,b:Int,direction:Float=0.0)
		'Prepare
		Local distance:Float=1.0
				
		'Set particle
		_points[_index].x=x
		_points[_index].y=y
		_points[_index].r=r
		_points[_index].g=g
		_points[_index].b=b
		_points[_index].active=Rnd(ParticleLife-20,ParticleLife)
		
		'Validate
		Select type
			Case ParticleType.Random
				direction=Rnd(0,360)
				distance=Rnd(3,11)
				_points[_index].dx=Cos(direction)*distance
				_points[_index].dy=Sin(direction)*distance
			Case ParticleType.Trail
				direction+=Rnd(-1,1)
				_points[_index].dx=Cos(direction)
				_points[_index].dy=Sin(direction)
				'Reduce life
				_points[_index].active/=2
			Case ParticleType.Explosion
				direction=Rnd(0,360)
				distance=Rnd(0.5,3.0)
				_points[_index].dx=Cos(direction)*distance
				_points[_index].dy=Sin(direction)*distance		
		End
		
		'Finalise
		_points[_index].dx=_points[_index].dx*1.5
		_points[_index].dy=_points[_index].dy*1.5
		_points[_index].x+=_points[_index].dx
		_points[_index].y+=_points[_index].dy
		
		'Increment
		_index=(_index+1) Mod NumParticles		
	End Method
	
End Class

Struct ParticlePoint
	Field x:Float=0.0
	Field y:Float=0.0
	Field dx:Float=0.0
	Field dy:Float=0.0
	Field r:Float=0
	Field g:Float=0
	Field b:Float=0
	Field active:Int=0
	Field decay:Float=0.95
	
	Method Update:Void()
		'Update
		x+=dx
		y+=dy
		dx*=decay
		dy*=decay
		
		'Validate
		If (x<-5) x=GAME.Width+5
		If (x>GAME.Width+5) x=-5
		If (y<-5) y=GAME.Height+5
		If (y>GAME.Height+5) y=-5
		
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