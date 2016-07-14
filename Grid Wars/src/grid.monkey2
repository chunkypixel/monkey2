'-----------------------------------------------------------------------
'
'  Based on the BlitzMax code of Grid Wars by Mark Incitti
'  - More examples to be completed
'  - Need to work out how to transfer over OpenGL calls
'
'  Code has been modulerized and Struct'd to reduce memory
'
'-----------------------------------------------------------------------

'Image
#Import "../assets/gfx/particle.png"
Global particleImage:Image

Struct GridPoint
	Field ox:Float
	Field oy:Float
	Field x:Float
	Field y:Float
	Field dx:Float
	Field dy:Float
		
	Method Update(xx:Float,yy:Float)
		If (Abs(xx-x)>2) dx+=Sgn(xx-x)
		If (Abs(yy-y)>2) dy+=Sgn(yy-y)
		
		If (Abs(ox-x)>1)
			x=x+Sgn(ox-x)
			dx+=Sgn(ox-x)/2
		Else
			x=ox
		End
		
		If (Abs(oy-y)>1)
			y=y+Sgn(oy-y)
			dy+=Sgn(oy-y)/2
		Else
			y=oy
		End
		
		dx=dx*.899
		dy=dy*.899		
		x=x+dx
		y=y+dy		
	End

	Method Disrupt(xx:Float,yy:Float)
		If (Abs(xx)>8) xx=xx/16
		If (Abs(yy)>8) yy=yy/16
		
		dx=dx+xx
		dy=dy+yy
		
		Local speed:Float=dx*dx+dy*dy
		If (speed>160) ' 128
			dx=dx/speed*128
			dy=dy/speed*128
		End	
	End
End Struct

Class Grid
Private
	Field _points:GridPoint[,]
	Field _gwLow:Int
	Field _gwHi:Int
	Field _ghLow:Int
	Field _ghHi:Int
	Field _playfieldWidth:Int=1024
	Field _playfieldHeight:Int=768
	Field _numPointsWidth:Int=0
	Field _numPointsHeight:Int=0
	Field _colors:ColorCycle
Public
	Field Opacity:Float=0.75
	Field Hilight:Int=4
	Field Style:Int=5
	Field GridWidth:Int=16
	Field GridHeight:Int=16
	Field Rotation:Float=270.0
	Field CycleColors:Bool=True
	
	Method New(width:Int=1024,height:Int=768,style:Int=5)
		'Images
		particleImage=Image.Load("asset::particle.png",TextureFlags.Filter)
		particleImage.Handle=New Vec2f(0.5,0.5)
		
		'Store
		_playfieldWidth=width
		_playfieldHeight=height
		Self.Style=style
		
		'Initialise
		_points=New GridPoint[_playfieldWidth/4+2,_playfieldHeight/4+2]
		_colors=New ColorCycle()
		
		'Reset	
		Self.Reset()
			
	End

	Method Reset()
		'Calc
		_numPointsWidth=_playfieldWidth/Self.GridWidth
		_numPointsHeight=_playfieldHeight/Self.GridHeight
		
		'Process
		For Local a:int=0 To _numPointsWidth
			For local b:int=0 To _numPointsHeight
				_points[a,b].ox=a*Self.GridWidth
				_points[a,b].oy=b*Self.GridHeight
				_points[a,b].x=a*Self.GridWidth
				_points[a,b].y=b*Self.GridHeight
				_points[a,b].dx=0
				_points[a,b].dy=0
			Next
		Next
			
	End
	
	Method Update()
		'Update colors
		_colors.Update()
						
		'Process
		For Local a:Int = 1 To _numPointsWidth-1
			For Local b:Int = 1 To _numPointsHeight-1
				Local xx:Float=0.0
				xx+=_points[a-1,b].x
				xx+=_points[a,b-1].x
				xx+=_points[a,b+1].x
				xx+=_points[a+1,b].x
				xx=xx/4
	
				Local yy:Float=0.0
				yy+=_points[a-1,b].y
				yy+=_points[a,b-1].y
				yy+=_points[a,b+1].y
				yy+=_points[a+1,b].y
				yy=yy/4
				
				_points[a,b].Update(xx,yy)
				
			Next
		Next
			
	End

	Method Render(canvas:Canvas)
		'Fullgrid
		_gwLow=0
		_gwHi=_numPointsWidth
		_ghLow=0
		_ghHi=_numPointsHeight
		
		'Canvas
		canvas.Alpha=Abs(Self.Opacity)
		canvas.BlendMode=BlendMode.Additive	'LIGHTBLEND
		canvas.LineWidth=2.0	'For now make all lines >1.0 for smoothing
		
		'Color
		If (Not Self.CycleColors) canvas.Color=GetColor(32,80,200)
		If (Self.CycleColors) canvas.Color=_colors.Color()

		'Render style
		Select Self.Style
			Case 0				
				Self.RenderGridPointsA(canvas)
			Case 1
				Self.RenderGridPointsB(canvas)
			Case 2
				Self.RenderGridPointsC(canvas)
			Case 3
				Self.RenderGridLines2A(canvas)
			Case 4
				Self.RenderGridLines2B(canvas)
			Case 5
				Self.RenderGridLines2C(canvas)
			Case 6
				Self.RenderGridLines4(canvas)
			Case 7
				Self.RenderGridLines5(canvas)
			Case 8
				Self.RenderGridLines6A(canvas)
			Case 9
				Self.RenderGridLines6B(canvas)
			Default
				'Draw nothing
		End
		
		'Reset
		canvas.Alpha=1.0
		canvas.BlendMode=BlendMode.Alpha
		canvas.Color=Color.White
		canvas.LineWidth=1.0
		
	End
		
	Method Shockwave(x:Int,y:Int)
		'Prepare
		Local a:Int=(x/Self.GridWidth)
		Local b:Int=(y/Self.GridHeight)
		
		'Process
		For Local xx:Int = -3 To 3
			For Local yy:Int = -3 To 3
				If (xx*xx+yy*yy<10)
					If (a+xx>0)
						If (a+xx<=_numPointsWidth)'-1
							If (b+yy>0)
								If (b+yy<=_numPointsHeight)'-1
									_points[a+xx,b+yy].Disrupt(4*(_points[a+xx,b+yy].x-x),4*(_points[a+xx,b+yy].y-y))								
								End
							End
						End
					End
				EndIf
			Next
		Next	
		
	End 
	
	Method BombShockwave(x:Int,y:Int)
		'Prepare
		Local a:Int=(x/Self.GridWidth)
		Local b:Int=(y/Self.GridHeight)

		'Process
		For Local xx:Int=-300 To 300
			For Local yy:Int=-300 To 300
				If (xx*xx+yy*yy<100000000)
					If (a+xx>0)
						If (a+xx<=_numPointsWidth)
							If (b+yy>0)
								If (b+yy<=_numPointsHeight)
									_points[a+xx,b+yy].Disrupt(0.6*(_points[a+xx,b+yy].x-x),0.6*(_points[a+xx,b+yy].y-y))
								End
							End
						End
					End
				End
			Next
		Next	
		
	End
	
	Method Push(x1:Float,y1:Float,size:Int=4,amnt:Float=1)
		'Prepare
		Local a:Int=(x1/Self.GridWidth)
		Local b:Int=(y1/Self.GridHeight)
				
		'Process
		For Local xx:Int=-size To size
			For Local yy:Int=-size To size
				If (a+xx>0)
					If(a+xx<=_numPointsWidth)'-2
						If (b+yy>0)
							If (b+yy<=_numPointsHeight)'-2
								Local diffx:Float=_points[a+xx,b+yy].ox-x1
								Local diffy:Float=_points[a+xx,b+yy].oy-y1
								Local diffxo:Float=_points[a+xx,b+yy].ox-_points[a+xx,b+yy].x
								Local diffyo:Float=_points[a+xx,b+yy].oy-_points[a+xx,b+yy].y								
								Local dist:Float=diffy*diffy+diffx*diffx
								Local disto:Float=diffyo*diffyo+diffxo*diffxo
								
								If (dist>1 And disto<400)
									If (dist<50*50)
										_points[a+xx,b+yy].dx+=diffx*amnt '/dist*amnt
										_points[a+xx,b+yy].dy+=diffy*amnt '/dist*amnt
									End										
								End						
							End
						End
					End
				End
			Next
		Next
			
	End
	
	Method Pull(x1:float,y1:float,size:Int=4,amnt:Float=4)
		'Prepare
		Local a:Int=(x1/Self.GridWidth)
		Local b:Int=(y1/Self.GridHeight)
						
		'Process
		For Local xx:Int=-size To size
			For Local yy:Int=-size To size
				If (a+xx>0)
					If (a+xx<=_numPointsWidth)'-2
						If (b+yy>0)
							If (b+yy<=_numPointsHeight)'-2
								If (xx*xx+yy*yy<size*size)							
									Local diffx:Float=_points[a+xx,b+yy].x-x1
									Local diffy:Float=_points[a+xx,b+yy].y-y1
									Local dist:Float=Sqrt(diffx*diffx+diffy*diffy)
									
									If (dist>0)
										_points[a+xx,b+yy].dx-=diffx/dist*amnt  '*(1-(dist*dist)/(sz*sz*4*256))
										_points[a+xx,b+yy].dy-=diffy/dist*amnt  '*(1-(dist*dist)/(sz*sz*4*256))
									End
									
								End
							End
						End
					End
				End
				
			Next
		Next	
	
	End
	
Private
	'Was DrawGridPoints
	Method RenderGridPointsA(canvas:Canvas)
	    Local a:Int,b:Int
	    Local boldWidth:Int=Self.Hilight-(_gwLow Mod Self.Hilight)
	    Local boldHeight:Int=Self.Hilight-(_gwLow Mod Self.Hilight)
	
	    'canvas.LineWidth=1.0	    
	    For a=_gwLow To _gwHi-1
		   	For b=_ghLow To _ghHi-1
	    	   	canvas.DrawRect(_points[a,b].x,_points[a,b].y,2,2)
	        Next
		Next
	     
	    'canvas.LineWidth=2.0
	    For a=_gwLow+boldWidth To _gwHi-1 Step Self.Hilight
	    	For b=_ghLow To _ghHi-1
	       		canvas.DrawRect(_points[a,b].x,_points[a,b].y,3,3)
	    	Next
	    Next
	    For a=_gwLow To _gwHi-1
	      	For b=_ghLow+boldHeight To _ghHi-1 Step Self.Hilight
	        	canvas.DrawRect(_points[a,b].x,_points[a,b].y,3,3)
	         Next
	    Next	
      
	End
	
    Method RenderGridPointsB(canvas:Canvas)
     	Local a:Int,b:Int
		Local boldWidth:Int=Self.Hilight-(_gwLow Mod Self.Hilight)
	    Local boldHeight:Int=Self.Hilight-(_gwLow Mod Self.Hilight)

	    'canvas.LineWidth=2.0
        
        For a=_gwLow+1 To _gwHi-1
         	For b=_ghLow+1 To _ghHi-1
            	canvas.DrawRect(_points[a,b].x,_points[a,b].y,2,2)
            Next
        Next
        For a=_gwLow+boldWidth+1 To _gwHi-1 Step Self.Hilight
         	For b=_ghLow+1 To _ghHi-1
            	canvas.DrawRect(_points[a,b].x,_points[a,b].y,4,4)
            Next
        Next
        For a=_gwLow+1 To _gwHi-1
         	For b=_ghLow+boldHeight+1 To _ghHi-1 Step Self.Hilight
            	canvas.DrawRect(_points[a,b].x,_points[a,b].y,4,4)
            Next
        Next
        
 	End 

	Method RenderGridPointsC(canvas:Canvas)
	    Local boldWidth:Int=Self.Hilight-(_gwLow Mod Self.Hilight)
	    Local boldHeight:Int=Self.Hilight-(_ghLow Mod Self.Hilight)
				
		For Local a:int=_gwLow+1 To _gwHi-1
			For Local b:int=_ghLow+1 To _ghHi-1
				Local alp:Float=Self.Opacity
				If ((b+boldHeight) Mod Self.Hilight=0) alp+=0.25
				If ((a+boldWidth) Mod Self.Hilight=0) alp+=0.25
				canvas.Alpha=alp
				canvas.DrawImage(particleImage,_points[a,b].x,_points[a,b].y)',0,1.5,1.5) 
			Next
		Next
		
	End 
	
	'Was DrawGridLines
	Method RenderGridLines1(canvas:Canvas)
	    Local boldWidth:Int=Self.Hilight-(_gwLow Mod Self.Hilight)
	    Local boldHeight:Int=Self.Hilight-(_ghLow Mod Self.Hilight)
		
		canvas.Alpha=0.9
		For Local a:Int = _gwLow+boldWidth To _gwHi-Self.Hilight Step Self.Hilight
			For Local b:Int = _ghLow+boldHeight-Self.Hilight To _ghHi-Self.Hilight Step Self.Hilight
				canvas.DrawLine(_points[a,b].x,_points[a,b].y,_points[a,b+Self.Hilight].x,_points[a,b+Self.Hilight].y)
			Next		
		Next
		For Local b:Int = _ghLow+boldHeight To _ghHi-Self.Hilight Step Self.Hilight
			For Local a:Int = _gwLow+boldWidth-Self.Hilight To _gwHi-Self.Hilight Step Self.Hilight
				canvas.DrawLine(_points[a,b].x,_points[a,b].y,_points[a+Self.Hilight,b].x,_points[a+Self.Hilight,b].y)
			Next
		Next	
	End
	
	Method RenderGridLines2A(canvas:Canvas)
	    Local colB:Float=0.0
	    Local boldWidth:Int=2-(_gwLow Mod 2)
	    Local boldHeight:Int=2-(_ghLow Mod 2)
	    Local delX:Float=0.0,delY:Float=0.0
	    Local xy:=New Float[8]

        For Local a:Int=_gwLow+boldWidth-2 To _gwHi-1 Step 1
        	 For Local b:int=_ghLow+boldHeight-2+(a Mod 2) To _ghHi-1 Step 2
             	xy[0]=_points[a,b].x
                xy[1]=_points[a,b].y
                xy[2]=_points[a+1,b].x
                xy[3]=_points[a+1,b].y
                xy[4]=_points[a+1,b+1].x
                xy[5]=_points[a+1,b+1].y
                xy[6]=_points[a,b+1].x
                xy[7]=_points[a,b+1].y

                delX=xy[4]-xy[0]-16
                delY=xy[5]-xy[1]-16
                If (delX<delY) Then delX=delY
                If (delX<0) delX=0
                If (delX>90) delX=90           
               	colB=Sin(delX)

                canvas.Color=GetColor(20+235*colB,20+100*colB,180-140*colB)
                canvas.Alpha=((1-colB)*0.7+0.3)            
				canvas.DrawPoly(xy)
				
			Next
		Next
			
	End

	Method RenderGridLines2B(canvas:Canvas)
	    Local boldWidth:Int=2-(_gwLow Mod 2)
	    Local boldHeight:Int=2-(_ghLow Mod 2)
	    Local xy:=New Float[8]

        For Local a:Int=_gwLow+boldWidth-2 To _gwHi-1 Step 1
        	For Local b:int=_ghLow+boldHeight-2+(a Mod 2) To _ghHi-1 Step 2
             	xy[0]=_points[a,b].x
                xy[1]=_points[a,b].y
                xy[2]=_points[a+1,b].x
                xy[3]=_points[a+1,b].y
                xy[4]=_points[a+1,b+1].x
                xy[5]=_points[a+1,b+1].y
                xy[6]=_points[a,b+1].x
                xy[7]=_points[a,b+1].y         
				canvas.DrawPoly(xy)
				
			Next
		Next
			
	End
	
	Method RenderGridLines2C(canvas:Canvas)
		Local i:Int=0,j:Int=0
	    Local boldWidth:Int=2-(_gwLow Mod 2)
	    Local boldHeight:Int=2-(_ghLow Mod 2)
	    Local xy:=New Float[8]

        For Local a:Int=_gwLow+boldWidth-2 To _gwHi-1 Step 1
        	j+=1
        	For Local b:int=_ghLow+boldHeight-2+(a Mod 2) To _ghHi-1 Step 2
        		i+=1
             	xy[0]=_points[a,b].x
                xy[1]=_points[a,b].y
                xy[2]=_points[a+1,b].x
                xy[3]=_points[a+1,b].y
                xy[4]=_points[a+1,b+1].x
                xy[5]=_points[a+1,b+1].y
                xy[6]=_points[a,b+1].x
                xy[7]=_points[a,b+1].y
                canvas.Alpha=(Self.Opacity-0.25*(Sin(_colors.Green+i)+Cos(j)))         
				canvas.DrawPoly(xy)
				
			Next
		Next
			
	End
		
    Method RenderGridLines4(canvas:Canvas)
	    Local colB:Float=0.0
	    Local boldWidth:Int=2-(_gwLow Mod 2)
	    Local boldHeight:Int=2-(_ghLow Mod 2)
	    Local delX:Float=0.0,delY:Float=0.0
	    Local xy:=New Float[8]

        For Local a:Int=_gwLow+boldWidth-2 To _gwHi-1 Step 1
        	 For Local b:int=_ghLow+boldHeight-2+(a Mod 2) To _ghHi-1 Step 2
             	xy[0]=_points[a,b].x
                xy[1]=_points[a,b].y
                xy[2]=_points[a+1,b].x
                xy[3]=_points[a+1,b].y
                xy[4]=_points[a+1,b+1].x
                xy[5]=_points[a+1,b+1].y
                xy[6]=_points[a,b+1].x
                xy[7]=_points[a,b+1].y

                delX=xy[4]-xy[0]-16
                delY=xy[5]-xy[1]-16
                If (delX<delY) Then delX=delY
                If (delX<0) 
                	colB=0.0
                Elseif(delX>90)
                	colB=1.0
                Else
                	colB=Sin(delX)
                End

                canvas.Color=GetColor(20+235*colB,20+100*colB,180-140*colB)
                canvas.Alpha=((1-colB)*0.3+0.7)            
               	'canvas.LineWidth=(2.0+colB*2)
                canvas.DrawLine(xy[0],xy[1],xy[2],xy[3])
                canvas.DrawLine(xy[2],xy[3],xy[4],xy[5])
                canvas.DrawLine(xy[4],xy[5],xy[6],xy[7])
                canvas.DrawLine(xy[6],xy[7],xy[0],xy[1])
			Next
		Next

	End	
	
	Method RenderGridLines5(canvas:Canvas)
	    Local colB:Float=0.0
	    Local boldWidth:Int=2-(_gwLow Mod 2)
	    Local boldHeight:Int=2-(_ghLow Mod 2)
	    Local delX:Float=0.0,delY:Float=0.0
	    Local xy:=New Float[8]
	
        For Local a:Int=_gwLow+boldWidth-2 To _gwHi-1 Step 1
        	 For Local b:int=_ghLow+boldHeight-2+(a Mod 2) To _ghHi-1 Step 2
             	xy[0]=_points[a,b].x
                xy[1]=_points[a,b].y
                xy[2]=_points[a+1,b].x
                xy[3]=_points[a+1,b].y
                xy[4]=_points[a+1,b+1].x
                xy[5]=_points[a+1,b+1].y
                xy[6]=_points[a,b+1].x
                xy[7]=_points[a,b+1].y
	
				delX=xy[4]-xy[0]-16
				delY=xy[5]-xy[1]-16
                If (delX<delY) Then delX=delY
                If (delX<0) 
                	colB=0.0
                Elseif(delX>90)
                	colB=1.0
                Else
                	colB=Sin(delX)
                End
	
				canvas.Color=GetColor(128+127*colB,15+105*colB,63-23*colB)
				canvas.Alpha=(colB*0.2+0.6)
               	'canvas.LineWidth=(2.0+colB*1.5)
				canvas.DrawLine(xy[0],xy[1],xy[4],xy[5])
				canvas.DrawLine(xy[6],xy[7],xy[2],xy[3])
			Next
		Next
	
	End

    Method RenderGridLines6A(canvas:Canvas)
	    Local colB:Float=0.0
	    Local alpha:Float=0.0
	    Local boldWidth:Int=2-(_gwLow Mod 2)
	    Local boldHeight:Int=2-(_ghLow Mod 2)
	    Local delX:Float=0.0,delY:Float=0.0
	    Local x:Int=0,y:Int=0
	    Local xy:=New Float[8]
		
		'Process
		For Local b:Int=_ghLow+boldHeight-2 To _ghHi-1 Step 1
			y+=1
			x=0
			For Local a:Int=_gwLow+boldWidth-2 To _gwHi-1 Step 1
				x+=1
				If (x>1)
					xy[0]=xy[2]
					xy[1]=xy[3]
					xy[6]=xy[4]
					xy[7]=xy[5]
				Else
					xy[0]=_points[a,b].x
					xy[1]=_points[a,b].y
					xy[6]=_points[a,b+1].x
					xy[7]=_points[a,b+1].y
				End
				xy[2]=_points[a+1,b].x
				xy[3]=_points[a+1,b].y
				xy[4]=_points[a+1,b+1].x
				xy[5]=_points[a+1,b+1].y

				delX=xy[4]-xy[0]-16
				delY=xy[5]-xy[1]-16
				If (delX<delY) delX=delY
				If (delX<0)
					colB=0.0
				Elseif (delX>90)
					colB=1.0
				Else
					colB=Sin(delX)
				End If
				'colB=Sin(Min(90,Max(0,Max(delX,delY))))

				canvas.Color=GetColor(20+235*colB,20+100*colB,180-140*colB)
			    canvas.LineWidth=(2.0+colB*1.5)'2?
				alpha=(1-colB)*0.0+0.5
				If (a<_gwHi-1)
					If ((x Mod 4)>0)
						canvas.Alpha=alpha
					Else
						canvas.Alpha=(alpha+0.5)
					End
					canvas.DrawLine(xy[2],xy[3],xy[4],xy[5])
				End
				If (b<_ghHi-1)
					If ((y Mod 4)>0)
						canvas.Alpha=alpha
					Else
						canvas.Alpha=(alpha+0.5)
					End
					canvas.DrawLine(xy[4],xy[5],xy[6],xy[7])
				End
				
			Next
		Next
		
	End

    Method RenderGridLines6B(canvas:Canvas)
	    Local boldWidth:Int=2-(_gwLow Mod 2)
	    Local boldHeight:Int=2-(_ghLow Mod 2)
        Local x:Int=0,y:Int=0
 	   	Local xy:=New Float[8]
 	    	
	    'canvas.LineWidth=2.0

		For Local b:Int=_ghLow+boldHeight-2 To _ghHi-1 Step 1
			y+=1
			x=0
			For Local a:Int=_gwLow+boldWidth-2 To _gwHi-1 Step 1
            	x+=1
				If (x>1)
					xy[0]=xy[2]
					xy[1]=xy[3]
					xy[6]=xy[4]
					xy[7]=xy[5]
				Else
					xy[0]=_points[a,b].x
					xy[1]=_points[a,b].y
					xy[6]=_points[a,b+1].x
					xy[7]=_points[a,b+1].y
				End
				xy[2]=_points[a+1,b].x
				xy[3]=_points[a+1,b].y
				xy[4]=_points[a+1,b+1].x
				xy[5]=_points[a+1,b+1].y
            	
                If (a<_gwHi-1)
					'If ((x Mod 4)>0)
					'	canvas.Alpha=alpha
					'Else
					'	canvas.Alpha=(alpha+0.25)
					'End
                	canvas.DrawLine(xy[2],xy[3],xy[4],xy[5])
                End
                If (b<_ghHi-1)
					'If ((y Mod 4)>0)
					'	canvas.Alpha=alpha
					'Else
					'	canvas.Alpha=(alpha+0.25)
					'End
               		canvas.DrawLine(xy[4],xy[5],xy[6],xy[7])
                End
			Next
		Next

	End
		
End