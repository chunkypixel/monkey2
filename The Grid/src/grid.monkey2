
'Images
#Import "../images/particle.png"

Global particleImage:Image

Struct GridPoint Extends Vec2f
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
End

Enum GridSize
	Normal
	Small
End

Class WonderGrid
Private
	Field _points:GridPoint[,]
	Field _gwLow:Int
	Field _gwHi:Int
	Field _ghLow:Int
	Field _ghHi:Int
	Field _xOffset:Int
	Field _yOffset:Int
	Field _playfieldWidth:Int=1024
	Field _playfieldHeight:Int=768
	Field _gridWidth:Int=16
	Field _gridHeight:Int=16
	Field _numPointsWidth:Int=0
	Field _numPointsHeight:Int=0
	Field _cycler:ColorCycler
Public
	Field Opacity:Float=0.85
	Field Size:Int=GridSize.Normal
	Field Hilight:Int=4
		
	Method New(width:Int=1024,height:Int=768)
		'Images
		particleImage=Image.Load("asset::particle.png",TextureFlags.Filter)
		particleImage.Handle=New Vec2f(0.5,0.5)
		
		'Store
		_playfieldWidth=width
		_playfieldHeight=height
		
		'Initialise
		_points=New GridPoint[_playfieldWidth/4+2,_playfieldHeight/4+2]
		For local a:Int = 0 To _playfieldWidth/4
			For Local b:Int = 0 To _playfieldHeight/4
				_points[a,b] = New GridPoint()
			Next
		Next
		'_points=New GridPoint[5120/4+2,4096/4+2]
		'For local a:Int = 0 To 1920/4
		'	For Local b:Int = 0 To 1200/4
		'		_points[a,b] = New GridPoint()
		'	Next
		'Next
		
		'Colors
		_cycler=New ColorCycler()
		
		'Reset	
		Self.Reset()
			
	End

	Method Reset()
		'Calc
		_numPointsWidth=_playfieldWidth/_gridWidth
		_numPointsHeight=_playfieldHeight/_gridHeight
		
		'Process
		For Local a:int=0 To _numPointsWidth
			For local b:int=0 To _numPointsHeight
				_points[a,b].ox=a*_gridWidth
				_points[a,b].oy=b*_gridHeight
				_points[a,b].x=a*_gridWidth
				_points[a,b].y=b*_gridHeight
				_points[a,b].dx=0
				_points[a,b].dy=0
			Next
		Next
			
	End
	
	Method Update()
		'Update colors
		_cycler.Update()
		
		'Determine offset
		_xOffset=0
		_yOffset=0
		If (Self.Size=GridSize.Small)
			_xOffset=-App.ActiveWindow.Width/8
			_yOffset=-App.ActiveWindow.Height/8
		End
				
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

	Method Render(canvas:Canvas,style:Int)
		'Fullgrid
		_gwLow=0
		_gwHi=_numPointsWidth
		_ghLow=0
		_ghHi=_numPointsHeight
		
		'Reduce size?
		If (Self.Size=GridSize.Small)
	        _gwLow=0
	        _gwHi=-_xOffset/_gridWidth*6
	        _ghLow= 0
			_ghHi=-_yOffset/_gridHeight*6
		End

		'Canvas
		canvas.Alpha=Abs(Self.Opacity)
		canvas.BlendMode=BlendMode.Alpha	'LIGHTBLEND

		'Render style
		Select style
			Case 0				
				'canvas.Color=GetColor(32,80,200)
				canvas.Color=_cycler.GetColor()
				Self.RenderGridPointsA(canvas)
			Case 1
				'canvas.Color=GetColor(32,80,200)
				canvas.Color=_cycler.GetColor()
				Self.RenderGridPointsB(canvas)
			Case 2
				'canvas.Color=GetColor(32,80,200)
				canvas.Color=_cycler.GetColor()
				Self.RenderGridPointsC(canvas,Self.Opacity)
			Case 3
				'canvas.Color=GetColor(32,80,200)
				'canvas.Color=_cycler.GetColor()
				Self.RenderGridLines4(canvas)
			Case 4
				'canvas.Color=GetColor(32,80,200)
				'canvas.Color=_cycler.GetColor()
				Self.RenderGridLines5(canvas)
			Case 5
				'canvas.Color=GetColor(32,80,200)
				'canvas.Color=_cycler.GetColor()
				Self.RenderGridLines6A(canvas)
			Case 6
				'canvas.Color=GetColor(32,80,200)
				canvas.Color=_cycler.GetColor()
				Self.RenderGridLines6B(canvas,Self.Opacity)
		End
		
	End
		
	Method Shockwave(x:Int,y:Int)
		'Prepare
		Local a:Int=(x/_gridWidth)
		Local b:Int=(y/_gridHeight)

		'Adjust?
		If (Self.Size=GridSize.Small)
			x+=_xOffset
			y+=_yOffset
		End
		
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
		Local a:Int=(x/_gridWidth)
		Local b:Int=(y/_gridHeight)

		'Adjust?
		If (Self.Size=GridSize.Small)
			x+=_xOffset
			y+=_yOffset
		End

		'Process
		For Local xx:Int=-300 To 300
			For Local yy:Int=-300 To 300
				If (xx*xx+yy*yy<100000000)
					If (a+xx>0)
						If (a+xx<=_numPointsWidth)
							If (b+yy>0)
								If (b+yy<=_numPointsHeight)
									_points[a+xx,b+yy].Disrupt(.6*(_points[a+xx,b+yy].x-x),.6*(_points[a+xx,b+yy].y-y))
								End
							End
						End
					End
				End
			Next
		Next	
		
	End
	
	Method Push(x1:Float,y1:Float,sz:Int=4,amnt:Float=1)
		'Prepare
		Local a:Int=(x1/_gridWidth)
		Local b:Int=(y1/_gridHeight)
		
		'Adjust?
		If (Self.Size=GridSize.Small)
			x1+=_xOffset
			y1+=_yOffset
		End
		
		'Process
		For Local xx:Int=-sz To sz
			For Local yy:Int=-sz To sz
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
	
	Method Pull(x1:float,y1:float,sz:Int=4,amnt:Float=4)
		'Prepare
		Local a:Int=(x1/_gridWidth)
		Local b:Int=(y1/_gridHeight)
				
		'Adjust?
		If (Self.Size=GridSize.Small)
			x1+=_xOffset
			y1+=_yOffset
		End
		
		'Process
		For Local xx:Int=-sz To sz
			For Local yy:Int=-sz To sz
				If (a+xx>0)
					If (a+xx<=_numPointsWidth)'-2
						If (b+yy>0)
							If (b+yy<=_numPointsHeight)'-2
								If (xx*xx+yy*yy<sz*sz)							
									Local diffx:Float=_points[a+xx,b+yy].x-x1
									Local diffy:Float=_points[a+xx,b+yy].y-y1
									Local dist:Float=Sqrt(diffx*diffx+diffy*diffy)
									
									If (dist>0)
	'									grid[a+xx,b+yy].fx:- diffx*(1-(dist)/(sz*sz*4*256))
	'									grid[a+xx,b+yy].fy:- diffy*(1-(dist)/(sz*sz*4*256))
										_points[a+xx,b+yy].dx-=diffx/dist*amnt  '*(1-(dist*dist)/(sz*sz*4*256))
										_points[a+xx,b+yy].dy-=diffy/dist*amnt  '*(1-(dist*dist)/(sz*sz*4*256))
	'									grid[a+xx,b+yy].fx = - diffx/dist*(1-(dist*dist)/(sz*sz*4*256))
	'									grid[a+xx,b+yy].fy = - diffy/dist*(1-(dist*dist)/(sz*sz*4*256))
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
	Method RenderGridPointsA(canvas:Canvas)
	    Local a:Int,b:Int
	    Local boldWidth:Int=Self.Hilight-(_gwLow Mod Self.Hilight)
	    Local boldHeight:Int=Self.Hilight-(_gwLow Mod Self.Hilight)
	
	    canvas.Scale(1,1)
	    'SetLineWidth 1
	    For a=_gwLow To _gwHi-1
		   	For b=_ghLow To _ghHi-1
	    	   	canvas.DrawRect(_points[a,b].x-_xOffset,_points[a,b].y-_yOffset,2,2)
	        Next
		Next
	     
	    'SetLineWidth 2
	    For a=_gwLow+boldWidth To _gwHi-1 Step Self.Hilight
	    	For b=_ghLow To _ghHi-1
	       		canvas.DrawRect(_points[a,b].x-_xOffset,_points[a,b].y-_yOffset,3,3)
	    	Next
	    Next
	    For a=_gwLow To _gwHi-1
	      	For b=_ghLow+boldHeight To _ghHi-1 Step Self.Hilight
	        	canvas.DrawRect(_points[a,b].x-_xOffset,_points[a,b].y-_yOffset,3,3)
	         Next
	    Next	
      
	End
	
    Method RenderGridPointsB(canvas:Canvas)
     	Local a:Int,b:Int
		Local boldWidth:Int=Self.Hilight-(_gwLow Mod Self.Hilight)
	    Local boldHeight:Int=Self.Hilight-(_gwLow Mod Self.Hilight)

        canvas.Scale(1,1)
        'SetLineWidth 2
        For a=_gwLow+1 To _gwHi-1
         	For b=_ghLow+1 To _ghHi-1
            	canvas.DrawRect(_points[a,b].x-_xOffset,_points[a,b].y-_yOffset,2,2)
            Next
        Next
        For a=_gwLow+boldWidth+1 To _gwHi-1 Step Self.Hilight
         	For b=_ghLow+1 To _ghHi-1
            	canvas.DrawRect(_points[a,b].x-_xOffset,_points[a,b].y-_yOffset,4,4)
            Next
        Next
        For a=_gwLow+1 To _gwHi-1
         	For b=_ghLow+boldHeight+1 To _ghHi-1 Step Self.Hilight
            	canvas.DrawRect(_points[a,b].x-_xOffset,_points[a,b].y-_yOffset,4,4)
            Next
        Next
        
 	End 

	Method RenderGridPointsC(canvas:Canvas,alpha:Float)
	    Local boldWidth:Int=Self.Hilight-(_gwLow Mod Self.Hilight)
	    Local boldHeight:Int=Self.Hilight-(_gwLow Mod Self.Hilight)
		
		'canvas.Scale(1.5,1.5)
		For Local a:int=_gwLow+1 To _gwHi-1
			For Local b:int=_ghLow+1 To _ghHi-1
				Local alp:Float=alpha
				If ((b+boldHeight) Mod Self.Hilight=0) alp+=0.25
				If ((a+boldWidth) Mod Self.Hilight=0) alp+=0.25
				canvas.Alpha=alp
				canvas.DrawImage(particleImage,_points[a,b].x-_xOffset,_points[a,b].y-_yOffset) 
			Next
		Next
		'canvas.Scale(1,1)
		
	End 

    Method RenderGridLines4(canvas:Canvas)
	    Local colB:Float=0.0
	    Local boldWidth:Int=2-(_gwLow Mod 2)
	    Local boldHeight:Int=2-(_ghLow Mod 2)
	    Local delX:Float=0.0,delY:Float=0.0
	    Local xy:=New Float[8]

        'glEnable GL_LINE_SMOOTH; glHint GL_LINE_SMOOTH, GL_NICEST
		canvas.Scale(1,1)

        For Local a:Int=_gwLow+boldWidth-2 To _gwHi-1 Step 1
        	 For Local b:int=_ghLow+boldHeight-2+(a Mod 2) To _ghHi-1 Step 2
             	xy[0]=_points[a,b].x-_xOffset
                xy[1]=_points[a,b].y-_yOffset
                xy[2]=_points[a+1,b].x-_xOffset
                xy[3]=_points[a+1,b].y-_yOffset
                xy[4]=_points[a+1,b+1].x-_xOffset
                xy[5]=_points[a+1,b+1].y-_yOffset
                xy[6]=_points[a,b+1].x-_xOffset
                xy[7]=_points[a,b+1].y-_yOffset

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
                canvas.Alpha=((1-colB)*.3+0.7)
                'SetLineWidth(1+colB*2)
                canvas.DrawLine(xy[0],xy[1],xy[2],xy[3])',0)
                canvas.DrawLine(xy[2],xy[3],xy[4],xy[5])',0)
                canvas.DrawLine(xy[4],xy[5],xy[6],xy[7])',0)
                canvas.DrawLine(xy[6],xy[7],xy[0],xy[1])',0)
			Next
		Next

	End	
	
	Method RenderGridLines5(canvas:Canvas)
	    Local colB:Float=0.0
	    Local boldWidth:Int=2-(_gwLow Mod 2)
	    Local boldHeight:Int=2-(_ghLow Mod 2)
	    Local delX:Float=0.0,delY:Float=0.0
	    Local xy:=New Float[8]

        'glEnable GL_LINE_SMOOTH; glHint GL_LINE_SMOOTH, GL_NICEST
		canvas.Scale(1,1)
	
        For Local a:Int=_gwLow+boldWidth-2 To _gwHi-1 Step 1
        	 For Local b:int=_ghLow+boldHeight-2+(a Mod 2) To _ghHi-1 Step 2
             	xy[0]=_points[a,b].x-_xOffset
                xy[1]=_points[a,b].y-_yOffset
                xy[2]=_points[a+1,b].x-_xOffset
                xy[3]=_points[a+1,b].y-_yOffset
                xy[4]=_points[a+1,b+1].x-_xOffset
                xy[5]=_points[a+1,b+1].y-_yOffset
                xy[6]=_points[a,b+1].x-_xOffset
                xy[7]=_points[a,b+1].y-_yOffset
	
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
				canvas.Alpha=(colB*.2+0.6)
				'SetLineWidth(1+colB*1.5)
				canvas.DrawLine(xy[0],xy[1],xy[4],xy[5])',0)
				canvas.DrawLine(xy[6],xy[7],xy[2],xy[3])',0)
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

		'glEnable GL_LINE_SMOOTH; glHint GL_LINE_SMOOTH, GL_NICEST
		canvas.Scale(1,1)

		For Local b:Int=_ghLow+boldHeight-2 To _ghHi-1 Step 1
			y+=1
			x=0
			For Local a:Int=_gwLow+boldWidth-2 To _gwHi-1 Step 1
				x+=1
				
				'Rem
				'If x>1 Then
				'	xy[6] = xy[4]
				'	xy[7] = xy[5]
				'Else
				'	xy[6] = grid[a,b+1].x-gxoff
				'	xy[7] = grid[a,b+1].y-gyoff
				'End If
				'xy[2] = grid[a+1,b].x-gxoff
				'xy[3] = grid[a+1,b].y-gyoff
				'xy[4] = grid[a+1,b+1].x-gxoff
				'xy[5] = grid[a+1,b+1].y-gyoff

				'delX=xy[2]-xy[6]-16;delY=xy[7]-xy[3]-16
				'End Rem
				
				If (x>1)
					xy[0]=xy[2]
					xy[1]=xy[3]
					xy[6]=xy[4]
					xy[7]=xy[5]
				Else
					xy[0]=_points[a,b].x-_xOffset
					xy[1]=_points[a,b].y-_yOffset
					xy[6]=_points[a,b+1].x-_xOffset
					xy[7]=_points[a,b+1].y-_yOffset
				End
				xy[2]=_points[a+1,b].x-_xOffset
				xy[3]=_points[a+1,b].y-_yOffset
				xy[4]=_points[a+1,b+1].x-_xOffset
				xy[5]=_points[a+1,b+1].y-_yOffset

				delX=xy[4]-xy[0]-16;delY=xy[5]-xy[1]-16
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
				'SetLineWidth(1+colB*1.5)'2?
				alpha=(1-colB)*.0+.5
				If (a<_gwHi-1)
					If ((x Mod 4)>0)
						canvas.Alpha=alpha
					Else
						canvas.Alpha=(alpha+0.5)
					End
					canvas.DrawLine(xy[2],xy[3],xy[4],xy[5])',0)
				End
				If (b<_ghHi-1)
					If ((y Mod 4)>0)
						canvas.Alpha=alpha
					Else
						canvas.Alpha=(alpha+0.5)
					End
					canvas.DrawLine(xy[4],xy[5],xy[6],xy[7])',0)
				End
			Next
		Next

	End

    Method RenderGridLines6B(canvas:Canvas,alpha:Float)
	    Local boldWidth:Int=2-(_gwLow Mod 2)
	    Local boldHeight:Int=2-(_ghLow Mod 2)
        Local x:Int=0,y:Int=0
 	   	Local xy:=New Float[8]
 	    	
		'SetLineWidth 2

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
					xy[0]=_points[a,b].x-_xOffset
					xy[1]=_points[a,b].y-_yOffset
					xy[6]=_points[a,b+1].x-_xOffset
					xy[7]=_points[a,b+1].y-_yOffset
				End
				xy[2]=_points[a+1,b].x-_xOffset
				xy[3]=_points[a+1,b].y-_yOffset
				xy[4]=_points[a+1,b+1].x-_xOffset
				xy[5]=_points[a+1,b+1].y-_yOffset
            	
                If (a<_gwHi-1)
					'If ((x Mod 4)>0)
					'	canvas.Alpha=alpha
					'Else
					'	canvas.Alpha=(alpha+0.5)
					'End
                	canvas.DrawLine(xy[2],xy[3],xy[4],xy[5])',0)
                End
                If (b<_ghHi-1)
					'If ((y Mod 4)>0)
					'	canvas.Alpha=alpha
					'Else
					'	canvas.Alpha=(alpha+0.25)
					'End
               		canvas.DrawLine(xy[4],xy[5],xy[6],xy[7])',0)
                End
			Next
		Next

	End
			
End

Class ColorCycler
Private
	Field _rColDelta:Float=-3
	Field _gColDelta:Float=5
	Field _bColDelta:Float=7
Public
	Field Red:Int=250
	Field Green:Int=20
	Field Blue:Int=30
	
	Method New()
	End
	
	Method Update(speed:Float=10)
		Self.Red=Self.Red+_rColDelta/10*speed
		If (Self.Red<0)
			Self.Red=0
			_rColDelta=Rnd(1,speed)
		Elseif (Self.Red>255)
			Self.Red=255
			_rColDelta=-Rnd(1,speed)
		End

		Self.Green=Self.Green+_gColDelta/10*speed
		If (Self.Green<0)
			Self.Green=0
			_gColDelta=Rnd(1,speed)
		Elseif (Self.Green>255)
			Self.Green=255
			_gColDelta=-Rnd(1,speed)
		End

		Self.Blue=Self.Blue+_bColDelta/10*speed
		If (Self.Blue<0)
			Self.Blue=0
			_bColDelta=Rnd(1,speed)
		Elseif (Self.Blue>255)
			Self.Blue=255
			_bColDelta=-Rnd(1,speed)
		End
		
	End
	
	Method GetColor:Color()
		Local r:Float=(Cast<Float>(Self.Red)/255)
		Local g:Float=(Cast<Float>(Self.Green)/255)
		Local b:Float=(Cast<Float>(Self.Blue)/255)
		Return New Color(r,g,b)
	End
	
End

Function GetColor:Color(red:Int,green:Int,blue:Int)
	Local r:Float=(Cast<Float>(red)/255)
	Local g:Float=(Cast<Float>(green)/255)
	Local b:Float=(Cast<Float>(blue)/255)
	Return New Color(r,g,b)
End