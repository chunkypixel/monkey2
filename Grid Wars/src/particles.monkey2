
Const NumParticles:Int=2048
Const ParticleLife:Int=40
Const ParticleDecay:Float=0.95

Class ParticleManager

Private
	Field _points:ParticlePoint[]
	Field _index:Int=0
Public

	Method New()
		'Initialise
		_points=New ParticlePoint[NumParticles]	
		
		'Reset
		Self.Reset()			
	End
	
	Method CreateParticles(x:Int,y:Int,style:Int=2,type:Int=0,particles:Int=32)
		'Prepare
		Local r:Int=Rnd(0,4)*64
		Local g:Int=Rnd(0,4)*64
		Local b:Int=Rnd(0,4)*64

		'Create
		Self.CreateParticles(x,y,style,type,r,g,b,particles)	
	End

	Method CreateParticles(x:Int,y:Int,style:Int=2,type:Int=0,r:Int,g:Int,b:Int,particles:Int=32)
		'Create
		For Local t:Int=0 Until particles
			Self.Create(x,y,style,type,r,g,b)
		Next	
	End
	
	Method CreateFireWorks(position:Int,style:Int=2,type:Int=0)
		'Prepare
		Local x:Int,y:Int
		Local r:Int=Rnd(0,4)*64
		Local g:Int=Rnd(0,4)*64
		Local b:Int=Rnd(0,4)*64
			
		'Randomise style?
		If (style>3) style=Int(Rnd(0,4))
					
		'Get location
		Select position
			Case 1
				If (Rnd()>=0.5)
					x=Rnd(100,App.ActiveWindow.Width-100)
					y=16
					If (Rnd()>=0.5) y=App.ActiveWindow.Height-16
				Else
					y=Rnd(50,App.ActiveWindow.Height-50)
					x=16
					If (Rnd()>=0.5) x=App.ActiveWindow.Width-16
				End
	
			Case 2
				x=App.ActiveWindow.Width/2
				y=App.ActiveWindow.Height/2
			Default
				x=Rnd(0,App.ActiveWindow.Width-100)
				y=Rnd(0,App.ActiveWindow.Height-50)
		
		End
		
		'Create
		For Local t:Int=0 To 63
			Self.Create(x,y,style,type,r,g,b)
		Next
	End
	
	Method Update()
		'Process
		For Local t:Int=0 To NumParticles-1
			If (_points[t].active>0) _points[t].Update()
		Next		
	End
	
	Method Reset()
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
			
	End
	
	Method Render(canvas:Canvas)
		Local r:Float,g:Float,b:Float
			
		'Prepare
		canvas.BlendMode=BlendMode.Additive
		canvas.TextureFilteringEnabled=True
		
		'Process
		For Local t:int=0 To NumParticles-1
			If (_points[t].active>0)
				Select _points[t].style
					Case 0
						'Get color
						r=Min(_points[t].r*1.25,255.0)
						g=Min(_points[t].g*1.25,255.0)
						b=Min(_points[t].b*1.25,255.0)
						canvas.Color=GetColor(r,g,b)
						
						'Draw
						canvas.LineWidth=2.0
						canvas.Alpha=1.0
						canvas.DrawLine(_points[t].x,_points[t].y,_points[t].x+_points[t].dx,_points[t].y+_points[t].dy)
									
					Case 1						
						'Get color
						r=Min(_points[t].r*1.25,255.0)
						g=Min(_points[t].g*1.25,255.0)
						b=Min(_points[t].b*1.25,255.0)
						canvas.Color=GetColor(r,g,b)
						
						'Draw
						canvas.LineWidth=3.0
						canvas.Alpha=0.8
						canvas.DrawLine(_points[t].x,_points[t].y,_points[t].x+_points[t].dx,_points[t].y+_points[t].dy)
									
					Case 2
						'Get color
						r=Min(_points[t].r*1.5,255.0)
						g=Min(_points[t].g*1.5,255.0)
						b=Min(_points[t].b*1.5,255.0)
						canvas.Color=GetColor(r,g,b)
						
						'Draw
						canvas.LineWidth=2.0
						canvas.Alpha=1.0
						canvas.DrawImage(particleImage,_points[t].x+_points[t].dx,_points[t].y+_points[t].dy,0,0.5,0.5)		
										
					Case 3 
						'BEST!
						'Get color
						r=Min(_points[t].r*1.25,255.0)
						g=Min(_points[t].g*1.25,255.0)
						b=Min(_points[t].b*1.25,255.0)
						canvas.Color=GetColor(r,g,b)
						
						'Draw (line)
						canvas.LineWidth=2.0
						canvas.Alpha=0.8
						canvas.DrawLine(_points[t].x,_points[t].y,_points[t].x+_points[t].dx,_points[t].y+_points[t].dy)				
						'Draw (image)
						canvas.Alpha=0.25
						canvas.DrawImage(particleImage,_points[t].x+_points[t].dx*1.0,_points[t].y+_points[t].dy*1.0)						
				End
			End
			
		Next
		
		'Reset
		canvas.BlendMode=BlendMode.Alpha
		canvas.Alpha=1.0
		canvas.LineWidth=1.0
			
	End
	
Private
	Method Create(x:Float,y:Float,style:Int,type:Int,r:Int,g:Int,b:Int,rot:Float=0.0,size:Int=1)
		'Prepare
		Local dir:Float
		Local mag:Float
				
		'Set particle
		_points[_index].x=x
		_points[_index].y=y
		_points[_index].r=r
		_points[_index].g=g
		_points[_index].b=b
		_points[_index].active=Rnd(ParticleLife-20,ParticleLife)
		_points[_index].style=style
		
		'Validate
		Select type
			Case 0
				'Random
				dir=Rnd(0,360)
				mag=Rnd(3,11)
				_points[_index].dx=Cos(dir)*mag
				_points[_index].dy=Sin(dir)*mag
			Case 1
				mag=16
				_points[_index].dx=Cos(rot)*mag
				_points[_index].dy=Sin(rot)*mag
				_points[_index].active=24
			Case 2
				mag=8
				_points[_index].dx=Cos(rot)*mag
				_points[_index].dy=Sin(rot)*mag
			Case 3
				' 3 dirs
				dir=120*Rnd(0,3)+rot
				mag=Rnd(3,10)			
				_points[_index].dx=Cos(dir)*mag
				_points[_index].dy=Sin(dir)*mag
			Case 4
				' 4 dirs
				dir=90*Rnd(0,4)+rot
				mag=Rnd(3,11)
				_points[_index].dx=Cos(dir)*mag
				_points[_index].dy=Sin(dir)*mag
			Case 5
				' 8 dirs
				dir=45*Rnd(0,8)+rot
				mag=Rnd(3,11)
				_points[_index].dx=Cos(dir)*mag
				_points[_index].dy=Sin(dir)*mag
			Case 6
				' any dir and speed
				mag=Rnd(0.5,2.0)			
				_points[_index].dx=Cos(rot)*mag
				_points[_index].dy=Sin(rot)*mag
			Case 7
				' random
				dir=Rnd(0,360)
				mag=Rnd(1,14)
				_points[_index].dx=Cos(dir)*mag
				_points[_index].dy=Sin(dir)*mag
		End
		
		'Finalise
		_points[_index].dx=_points[_index].dx*1.5
		_points[_index].dy=_points[_index].dy*1.5
		_points[_index].x+=_points[_index].dx*size
		_points[_index].y+=_points[_index].dy*size
		
		'Increment
		_index=(_index+1) Mod NumParticles
		
	End
	
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
	Field style:Int=0
	
	Method Update()
		x+=dx
		y+=dy
		If (x<=dx)
			dx=Abs(dx)
			x+=dx*2
		End
		If(x>App.ActiveWindow.Width-1-dx)
			dx=-Abs(dx)
			x+=dx*2
		End
		If (y<=dy)
			dy=Abs(dy)
			y+=dy*2
		End
		If (y>App.ActiveWindow.Height-1-dy)
			dy=-Abs(dy)
			y+=dy*2
		End
		dx*=ParticleDecay
		dy*=ParticleDecay
		
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
			active=200
		End
		
	End

End Struct