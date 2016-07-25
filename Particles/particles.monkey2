
'-----------------------------------------------------------------------
'
'  Based on BlitzMax code created by Mark Incitti
'
'-----------------------------------------------------------------------

Namespace myapp

#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

#Import "particle.png"
Global particleImage:Image

Const Size:=New Vec2i( 640,360 )
Const NumParticles:Int=768
Const ParticleLife:Int=40
Const ParticleDecay:Float=0.95

Global Colors:ColorCycle
Global Particles:ParticleManager
Global BlackHoles:BlackHoleManager
Global GravityParticles:Bool=True

Function Main()
	New AppInstance
	New MyWindow
	App.Run()
End

Class MyWindow Extends Window

Private
	Field _particles:ParticleManager
	Field _style:Int=3
	Field _counter:Int=0
Public

	Method New()
		'Create window
		Super.New( "Particles!",640,480,WindowFlags.Fullscreen )
		Layout="letterbox"
		ClearColor=New Color(0,0,0)
		Mouse.PointerVisible=True
		Style.BackgroundColor=GetColor(2,2,2)

		'Randomise
		SeedRnd(Millisecs())
		
		'Load image
		particleImage=Image.Load("asset::particle.png",TextureFlags.Filter)
		particleImage.Handle=New Vec2f(0.5,0.5)
		
		'Initialise 
		Particles=New ParticleManager()
		Colors=New ColorCycle()
		BlackHoles=New BlackHoleManager()
						
	End

	Method OnRender( canvas:Canvas ) Override
		Local detach:Bool=False
		
		'Increment
		_counter=(_counter+1) Mod 1000
		If (_counter=0) detach=True
		
		'Features
		If (Keyboard.KeyHit(Key.P)) _style=(_style+1) Mod 5
		If (Keyboard.KeyHit(Key.G)) GravityParticles=Not GravityParticles
		
		'Release particles?
		If(Rnd(0,100)>94) Particles.CreateFireWorks(0,_style)
		
		'Update
		Colors.Update()
		Particles.Update()
		If (GravityParticles) Particles.UpdateAffectedParticles()
		BlackHoles.Update()
		
		'Render
		App.RequestRender()
		BlackHoles.Render(canvas)
		Particles.Render(canvas)
				
		'Text
		canvas.Color=Color.White
		canvas.DrawText("Style: "+_style,4,App.ActiveWindow.Height-55)
		canvas.DrawText("Press 'P'",4,App.ActiveWindow.Height-40)
		canvas.DrawText("Press 'G'",4,App.ActiveWindow.Height-25)
		
	End
	
	Method OnKeyEvent( event:KeyEvent ) Override
	
		select event.Type
			Case EventType.KeyDown 
				If ( event.Key=Key.Enter And event.Modifiers & Modifier.Alt	) Fullscreen=Not Fullscreen	
				If ( event.Key=Key.Escape )	App.Terminate()		
		End
	
	End
	
	Method OnMeasure:Vec2i() Override	
		Return Size
		
	End
	
End

Class ParticleManager

Private
	Field _points:ParticlePoint[]
	Field _index:Int=0
	Field _count:Int=0
Public

	Method New()
		'Initialise
		_points=New ParticlePoint[NumParticles]				
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
		
		'Randomise
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
		'Increment
		_count=(_count+1)' Mod 2
		
		'Process
		For Local t:Int=0 To NumParticles-1
			If (_points[t].active>0) _points[t].Update()
		Next		
	End

	Method UpdateAffectedParticles()
		'Prepare
		Local start:Int=_count Mod 2
		Local spin:Float=3.0
		If (start=0) spin=-3.0
		
		'Process
		For Local blackHole:BlackHolePoint=Eachin BlackHoles.Points
			If (blackHole.active)
				For Local t:Int=start To NumParticles-1 Step 2
					If (_points[t].active>0)
						Local ddx:Float=blackHole.x-_points[t].x
						Local ddy:Float=blackHole.y-_points[t].y
						Local dist:Float=Sqrt(ddx*ddx+ddy*ddy)
						If (dist<blackHole.size*8 And dist>8)
							'towards the gcenter
							If (dist<blackHole.size/4)
								ddx=-ddx/dist
								ddy=-ddy/dist
								_points[t].dx=_points[t].dx+ddx/2'.75
								_points[t].dy=_points[t].dy+ddy/2'.75							
								_points[t].dx=_points[t].dx+ddy/spin'.75' / dist/4
								_points[t].dy=_points[t].dy-ddx/spin'.75' / dist/4							
							Else
								_points[t].active+=3	
								ddx=ddx/dist
								ddy=ddy/dist
								_points[t].dx=_points[t].dx+ddx/2'.75
								_points[t].dy=_points[t].dy+ddy/2'.75							
								_points[t].dx=_points[t].dx-ddy/spin'.75' / dist/4
								_points[t].dy=_points[t].dy+ddx/spin'.75' / dist/4							
							End
							
							Local speed:Float=(_points[t].dx*_points[t].dx+_points[t].dy*_points[t].dy)
							If (speed>12*12)
								Local spRoot:Float=Sqrt(speed)
								_points[t].dx=_points[t].dx/spRoot
								_points[t].dy=_points[t].dy/spRoot
							End
						End
					End
				Next
			End		
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
			_points[t].style=0
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
	Method Create(x:Float,y:Float,style:Int,type:Int,r:Int,g:Int,b:Int,rot:Float=0.0,size:Int=1,affected:Bool=false)
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
	Field active:Float=0
	Field style:Int=0
	
	Method Update()
		'Increment
		x+=dx
		y+=dy
		
		'Bounds
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
		
		'Reduce life
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

Class BlackHolePoint
	Field x:Float=0.0
	Field y:Float=0.0
	Field dx:Float=0.0
	Field dy:Float=0.0
	Field r:Float=0.0
	Field size:Float=0.0
	Field active:bool=False
	Field centerx:Float
	Field centery:Float
		
	Method Update()	
		'Increment
		r+=1
		x+=dx
		y+=dy
		
		'Bounds
		If (x<32)
			dx=Abs(dx)
			x+=dx
		ElseIf (x>App.ActiveWindow.Width-32)
			dx=-Abs(dx)
			x+=dx
		End
		If (y<32)
			dy=Abs(dy)
			y+=dy
		ElseIf (y>App.ActiveWindow.Height-32)
			dy=-Abs(dy)
			y+=dy
		EndIf 
		
		'Update
		centerx=(x+Sin(r*2)*size/2.5)
		centery=(y+Cos(r*2)*size/2.5)
				
	End
	
End Class

Class BlackHoleManager
	Field Points:List<BlackHolePoint>
	Field count:Int=0
	
	Method New()
		Points=New List<BlackHolePoint>
		Self.Reset()
	End
	
	Method Create(x:Float,y:Float,size:Float)
		'Validate
		If (Points.Count()>15) Return
		
		'Process
		Local p:BlackHolePoint=New BlackHolePoint()
		p.x=x
		p.y=y
		p.size=size
		p.centerx=x
		p.centery=y
		p.active=true
		p.r=Rnd(0,360)
		Local dir:Float=Rnd(0,360)
		Local mag:Float=Rnd(1,5)
		p.dx=Cos(dir)*mag
		p.dy=Sin(dir)*mag
		'Add
		Points.AddLast(p)
	End
	
	Method Reset()
		'Reset
		count=0
		
		'Create
		Self.Points.Clear()
		Self.Create(640/2+Rnd(-100,100),360/2+Rnd(-100,100),Rnd(12,50))
		Self.Create(640/2+Rnd(-100,100),360/2+Rnd(-100,100),Rnd(12,50))
		'Self.Create(640/2+Rnd(-100,100),360/2+Rnd(-100,100),Rnd(12,50))
		
	End	
	
	Method Update()
		'Process
		For Local p:BlackHolePoint=Eachin Points
			If (p.active) p.Update()
		End
	End
	
	Method Render(canvas:Canvas)
		For Local p:BlackHolePoint=Eachin Points
			If (p.active)
				canvas.Color=GetColor(4,4,4)
				canvas.DrawCircle(p.x,p.y,p.size)
			End
		End	
	End

End Class


Class TrailManager
Private
	Field _points:List<TrailPoint>
Public

	Method New()
		_points=New List<TrailPoint>()
	End

	Method Create(x:Float,y:Float,r:Float,b:Float,g:Float,dx:Float,dy:Float)
	
	End
	
	Method Update()
		For Local p:= Eachin _points
			p.Update()
			If (p.active<=0) _points.Remove(p)		
		Next
		
	End
	
	Method Render(canvas:Canvas)
		'Prepare
		canvas.LineWidth=2.0
		canvas.Alpha=0.23
		
		'Process
		For Local p:= Eachin _points
			canvas.Color=GetColor(p.r,p.g,p.b)
			canvas.DrawPoint(p.x,p.y)
			canvas.DrawImage(particleImage,p.x,p.y)
		Next
		
		'Finalse
		canvas.Color=Color.White
		canvas.LineWidth=1.0
		canvas.Alpha=1.9
	End
	
End Class

Struct TrailPoint
	Field x:Float=0.0
	Field y:Float=0.0
	Field dx:Float=0.0
	Field dy:Float=0.0
	Field r:Float=0
	Field g:Float=0
	Field b:Float=0
	Field active:Int=0
	
	Method Update()
		'Process
		active-=1
		If (active<28)
			r*=0.91
			g*=0.88
			b*=0.86
			x+=dx
			y+=dy
			dx*=0.999
			dy*=0.999
		End
	End
	
End Struct

Class ColorCycle
Private
	Field _rColDelta:Float=-3
	Field _gColDelta:Float=5
	Field _bColDelta:Float=7
Public
	Field Red:Float=250
	Field Green:Float=20
	Field Blue:Float=30
		
	Method Update(speed:Float=10.0)

		Self.Red+=(_rColDelta/10*speed)
		If (Self.Red<0)
			Self.Red=0
			_rColDelta=Rnd(1,speed)
		Elseif (Self.Red>255)
			Self.Red=255
			_rColDelta=-Rnd(1,speed)
		End

		Self.Green+=(_gColDelta/10*speed)
		If (Self.Green<0)
			Self.Green=0
			_gColDelta=Rnd(1,speed)
		Elseif (Self.Green>255)
			Self.Green=255
			_gColDelta=-Rnd(1,speed)
		End

		Self.Blue+=(_bColDelta/10*speed)
		If (Self.Blue<0)
			Self.Blue=0
			_bColDelta=Rnd(1,speed)
		Elseif (Self.Blue>255)
			Self.Blue=255
			_bColDelta=-Rnd(1,speed)
		End
		
	End
	
	Method Color:Color()
		Return GetColor(Self.Red,Self.Green,Self.Blue)
	End
	
End Class

Function GetColor:Color(red:Float,green:Float,blue:Float)
	Return New Color(red/255,green/255,blue/255)
End