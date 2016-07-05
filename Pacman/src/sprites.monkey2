Namespace pacman

'Assets
'Sprites
#Import "../images/yellow.png"
#Import "../images/redt.png"
#Import "../images/oranget.png"
#Import "../images/pinkt.png"
#Import "../images/cyant.png"

Global Sprites:=New Stack<Sprite> ' Contains all the sprites displayed on the screen
Global Yellow:PacmanSprite
Global Red:BlinkyGhostSprite
Global Orange:ClydeGhostSprite
Global Pink:PinkyGhostSprite
Global Cyan:InkyGhostSprite

Enum Direction
	Up
	Left
	Down
	Right
End

Enum GhostMode
    Pen
    LeavePen
	ReturnPen
	EnterPen
	Chase
	Scatter
	Frightened
End

Function InitialiseSprites()
	'Objects
	Yellow=New PacmanSprite("asset::yellow.png")
	Red=New BlinkyGhostSprite("asset::redt.png",New Vec2f(25,0))
	Pink=New PinkyGhostSprite("asset::pinkt.png",New Vec2f(2,0))
	Orange=New ClydeGhostSprite("asset::oranget.png",New Vec2f(0,35))
	Cyan=New InkyGhostSprite("asset::cyant.png",New Vec2f(27,35))
	
	'Testing
	'Yellow.SetPosition(5,17)
	'Red.SetPosition(5,17)
	'Yellow.SetDirection(Direction.Right)
	'Yellow.SetPosition(23,17)
	'Red.SetDirection(Direction.Right)
	'Red.SetPosition(23,17)	
	
	'Pink.SetPosition(12,14)
	'Pink.Mode=GhostMode.Chase
	'Pink.SetDirection(Direction.Right)
	'Orange.SetPosition(14,14)
	'Orange.Mode=GhostMode.Chase
	'Orange.SetDirection(Direction.Right)
	'Cyan.SetPosition(16,14)
	'Cyan.Mode=GhostMode.Chase
	'Cyan.SetDirection(Direction.Left)
End

Function UpdateSprites()
	For Local i:=0 Until Sprites.Length
		If (Sprites[i].Enabled) Sprites[i].Update()
	Next
End

Function RenderSprites(canvas:Canvas)
	For Local i:=0 Until Sprites.Length
		If (Sprites[i].Enabled) Sprites[i].Render(canvas)
	Next
End

Function ResetSprites()
	For Local i:=0 Until Sprites.Length
		Sprites[i].Reset()
	Next
End

Function SetGhostMode:Void(mode:Int)
	For Local i:=0 Until Sprites.Length
		Local ghost:GhostSprite=Cast<GhostSprite>(Sprites[i])
		If (ghost<>Null And ghost.Mode>GhostMode.ReturnPen) ghost.Mode=mode
	Next
	SetSpriteSpeed()
End

Function SetGhostReverseDirection:Void()
	For Local i:=0 Until Sprites.Length
		Local ghost:GhostSprite=Cast<GhostSprite>(Sprites[i])
		If (ghost<>Null) 
			Select ghost.Mode
				Case GhostMode.Chase,GhostMode.Scatter
					ghost.ReverseDirection=True
			End
		End
	Next
End

Function SetSpriteSpeed:Void()
	For Local i:=0 Until Sprites.Length
		Sprites[i].SetSpeed()				
	Next
	
End


Class Sprite
	Field X:Float=0
	Field Y:Float=0
	Field Blend:=BlendMode.Alpha
	Field Color:= New Color( 1,1,1,1 )
	Field Images:ImageCollection
	Field Frame:Int=0
	Field Rotation:Float=0.0
	Field Scale:=New Vec2f( 1,1 )
	Field Enabled:Bool=True
	Field Dir:Int=Direction.Up
	Field PrevDir:Int=Direction.Up
	Field Speed:Float=1.0
	
	Method New(image:string)
		' Prepare
		Self.Images=New ImageCollection(image,16,16)		
				
		' Store
		Sprites.Push(Self)
	End
	
	Property Tile:Vec2f()
		Return New Vec2f(Int((Self.X)/8),Int((Self.Y)/8))
	End
	
	Method Reset() Abstract
	
	Method SetSpeed() Abstract
	
	Method Update() Abstract

	Method Render(canvas:Canvas) Virtual
		'Debugger
		If (window.IsDebug)
			canvas.Color=Color.Green
			canvas.DrawRect(DisplayOffset.X+Int(Self.Tile.X*8),DisplayOffset.Y+Int(Self.Tile.Y*8),8,8)
		End
		
		'Draw
		canvas.Color=Color.White
		Self.Render(canvas,Self.Dir,New Vec2f(DisplayOffset.X+Int(Self.X)-8,DisplayOffset.Y+Int(Self.Y)-8))
	End
	
	Method Render(canvas:Canvas,frame:Int,position:Vec2f,flip:Bool=False)
		' Prepare
		Local scale:=Self.Scale

		' Validate
		If (frame=-1) frame=Self.Frame
		If (flip) scale=New Vec2f(-1,1)
		
		' Draw
		canvas.BlendMode=Self.Blend
		canvas.Color=Self.Color
		canvas.DrawImage(Self.Images.Item[frame],position,Self.Rotation,scale)	
	End
		
	'Method Update() Virtual
	'	'Auto movement pattern
	'	
	'	'Prepare
	'	Local moveX:Float=Self.X
	'	Local moveY:Float=Self.Y
	'	
	'	'Precalc next step
	'	Select Self.Dir
	'		Case Direction.Up
	'			moveY-=Speed
	'		Case Direction.Left
	'			moveX-=Speed
	'		Case Direction.Down
	'			moveY+=Speed
	'		Case Direction.Right
	'			moveX+=Speed
	'	End
	'	
	'	'Validate for changing position (centre of tile)
	'	If (Self.IsCentreTile(moveX,moveY))
	'		'Set new direction and tile
	'		Local nextTile:=New Vec2f(Int((moveX)/8),Int((moveY)/8))
	'		Self.SetDirection(GetNewDirection(nextTile,Self.Dir))
	'		
	'		'Update tile
	'		Self.Tile=nextTile
	'	End
	'	
	'	'Update position
	'	Self.X=moveX
	'	Self.Y=moveY			
    '
	'End

	Method SetPosition(x:Int,y:Int,offsetX:Int=4,offsetY:Int=4)
		SetPosition(New Vec2f(x,y),offsetX,offsetY)
	End	
	Method SetPosition(tile:Vec2f,offsetX:Int=4,offsetY:Int=4)
		'Self.Tile=tile
		Self.X=(tile.X*8)+offsetX
		Self.Y=(tile.Y*8)+offsetY
	End

	Method SetDirection(dir:Int)
		Self.PrevDir=Self.Dir
		Self.Dir=dir
	End
					
	Method IsCentreTile:Bool(x:Float,y:Float,xOffset:Int=4)
		Return ((Int(x) Mod 8)=xOffset And (Int(y) Mod 8)=4)
	End
	
	Method GetNewDirection:Int(tile:Vec2f)
		'Validate
		If (Grid[0,tile.X,tile.Y-1]=0 And Self.Dir<>Direction.Down And Self.PrevDir<>Direction.Down)
			Return Direction.Up
		Elseif(Grid[0,tile.X-1,tile.Y]=0 And Self.Dir<>Direction.Right And Self.PrevDir<>Direction.Right)
			Return Direction.Left
		Elseif(Grid[0,tile.X,tile.Y+1]=0 And Self.Dir<>Direction.Up And Self.PrevDir<>Direction.Up)
			Return Direction.Down
		End
		Return Direction.Right
	End
		
	Method CanMoveDirection:Bool(tile:Vec2f,moveDir:Int)
		'Validate
		Select moveDir
			Case Direction.Up
				If (tile.Y-1>=0) Return (Grid[0,tile.X,tile.Y-1]=0) 
			Case Direction.Down
				if (tile.Y+1<GridHeight) Return (Grid[0,tile.X,tile.Y+1]=0) 
			Case Direction.Left
				If (tile.X-1>=0) Return (Grid[0,tile.X-1,tile.Y]=0) 			
			Case Direction.Right
				if (tile.X+1<GridWidth) Return (Grid[0,tile.X+1,tile.Y]=0) 					
		End
		Return False
	End
	
End

Class GhostSprite Extends Sprite
	Field ScatterTargetTile:=New Vec2f(0,0)
	Field Mode:Int=GhostMode.Chase
	Field ReverseDirection:Bool=False
	Field ExitPenDir:Int=Direction.Left
	Field DotCounter:Int=0
	Field ReleaseOnDot:Int=0
	Field DotCounterActive:Bool=False
	
	Method New(image:string,scatterTargetTile:Vec2f)
		Super.New(image)
		Self.ScatterTargetTile=scatterTargetTile
	End
		
	'Provide Ghost Specific Targetting
	Method GetTargetTile:Vec2f() Abstract
	
	Method Update() Override
		'Debug
		If (Not window.MoveGhosts) return

		'Get current position
		Local moveX:Float=Self.X
		Local moveY:Float=Self.Y
		
		'Determine required IsCentre offset
		Local xTileOffset:Int=4
		Select Self.Mode
			Case GhostMode.Pen,GhostMode.LeavePen
				xTileOffset=0
		End
		
		'Precalc next step
		Self.SetSpeed()
		Select Self.Dir
			Case Direction.Up
				moveY-=Speed
			Case Direction.Left
				moveX-=Speed
			Case Direction.Down
				moveY+=Speed
			Case Direction.Right
				moveX+=Speed
		End
		
		'Prepare
		Local isCentreTile:bool=Self.IsCentreTile(moveX,moveY,xTileOffset)

		'Reverse direction?
		'Note: Ghosts can only reverse direction once centered on a tile
		If (Self.ReverseDirection And isCentreTile)	
			'Prepare
			Local reverseDir:Int=(Self.Dir+2) Mod 4
			
			'Validate (if in a corner a straight reverse may not work)
			If (Not CanMoveDirection(Self.Tile,reverseDir)) reverseDir=(Self.PrevDir+2) Mod 4
			
			'Update
			Self.SetDirection(reverseDir)
			Self.ReverseDirection=False
		End 

		'In a tunnel?
		If (isCentreTile And Self.Tile.X>=GridWidth-1 And Self.Dir=Direction.Right)
			Self.SetPosition(0,Self.Tile.Y,0,4)
			moveX=Self.X
			moveY=Self.Y
		Elseif (isCentreTile And Self.Tile.X<=0 And Self.Dir=Direction.Left) 
			Self.SetPosition(GridWidth-1,Self.Tile.Y,7,4)
			moveX=Self.X
			moveY=Self.Y
		End	

		'Prepare	
		Local nextTile:=New Vec2f(Int((moveX)/8),Int((moveY)/8))
		
		'Movement
		Select Self.Mode
			Case GhostMode.Pen
				'Validate if continue to move in direction otherwise switch to opposite
			    If (Not CanMoveDirection(nextTile,Self.Dir)) Self.Dir=(Self.Dir+2) Mod 4	
					
				'Ready to leave pen?
				If (isCentreTile And Self.DotCounter>=Self.ReleaseOnDot)
					'Prepare to validate leaving position
					Self.Dir=Direction.Up
					If (Self.Tile.X<14) Self.Dir=Direction.Right
					If (Self.Tile.X>14) Self.Dir=Direction.Left
					Self.Mode=GhostMode.LeavePen
					
				End If
				
			Case GhostMode.LeavePen
				'Ready to actually start leaving (must be centred on exit first)
				If (isCentreTile And Self.Tile.X=14)
					If (Self.Tile.Y>14)
						'Still leaving pen
						Self.Dir=Direction.Up
					Else
						'Left pen
						'TODO: If ghost mode changes when inside pen then will move right on exit
						Self.Dir=Self.ExitPenDir
						Self.Mode=GhostMode.Chase
					End

				End
				
			Default	
				'Validate for changing position (centre of tile)
				If (Self.IsCentreTile(moveX,moveY,xTileOffset))			
					'Set new direction and tile
					Select Self.Mode
						Case GhostMode.Chase,GhostMode.Scatter,GhostMode.ReturnPen
							'Determine target
							Local targetTile:Vec2f=GetTargetTile()

							'Get opposite of current dir
							'We need to exclude direction we are coming from
							Local oppositeDir:Int=(Self.Dir+2) Mod 4
							Local oppositePrevDir:Int=(Self.PrevDir+2) Mod 4
							
							'Is current dir available
							Local isCurrentDirAvailable:Bool=Self.CanMoveDirection(nextTile,Self.Dir)
							
							'Determine best available direction (order Up, Left, Down, Right)
							Local targetDir:Int=-1
							Local targetDistance:Int=-1
							Local targetCount:Int=0
							For Local dir:Int=0 To 3
								'Validate (exclude opposite direction to current)
								Local checkTargetDistance:Int=Self.FindTargetDistance(nextTile,targetTile,dir)
								If (checkTargetDistance>=0 And (checkTargetDistance<targetDistance Or targetDistance<0) And dir<>oppositeDir And dir<>oppositePrevDir)
									targetDistance=checkTargetDistance
									targetDir=dir
									targetCount+=1
								End
							Next

							'Is current dir available and do we not have a least 2 directions available
							If (isCurrentDirAvailable And targetCount<=2) targetDir=Self.Dir
							
							'Set
							Self.SetDirection(targetDir)

						Case GhostMode.Frightened
							'Note: There is a pseudo-random (PRNG) number to determine direction
							'      if it cannot move in that direction then choose a direction
							'      as follows: up,left,down,right
							'Note: Need to make sure we don't return from existing direction 

							'TODO: Implement above
							Self.SetDirection(Self.GetNewDirection(nextTile))

					End

				End
			
		End
				
		'Update position
		Self.X=moveX
		Self.Y=moveY			

	End
		
	Method Render(canvas:Canvas) Override
		Super.Render(canvas)
		
		'Debugging?
		If (window.IsDebug)	
			'Draw line to target
			Select Self.Mode
				case GhostMode.Chase,GhostMode.Scatter
					'Target
					Local targetTile:=GetTargetTile()
					canvas.Color=Color.Green
					canvas.DrawLine(DisplayOffset.X+(Self.Tile.X*8)+4,DisplayOffset.Y+(Self.Tile.Y*8)+4,DisplayOffset.X+(targetTile.X*8)+4,DisplayOffset.Y+(targetTile.Y*8)+4)
			End
		End
		
	End
	
	Method SetSpeed() Override
		'Validate
		Select Self.Mode
			Case GhostMode.Pen,GhostMode.LeavePen,GhostMode.EnterPen
				Self.Speed=0.50
			Case GhostMode.Frightened
				Self.Speed=0.50
			Default
				Self.Speed=0.75	
		End
		
		'In tunnel?
		If (Grid[1,Self.Tile.X,Self.Tile.Y]=1) Self.Speed=0.40
	End
		
Private
	Method FindTargetDistance:Int(tile:Vec2f,targetTile:Vec2f,dirToTarget:Int)		
		'Validate (special zones where ghost cannot move up)
		Local canMoveUp:Bool=True
		Select Self.Mode
			Case GhostMode.Chase,GhostMode.Scatter
				If (Grid[1,tile.X,tile.Y]=2) canMoveUp=False
		End
		
		'Process
		Select dirToTarget
			Case Direction.Up
				If (tile.Y>0 And Grid[0,tile.X,tile.Y-1]=0 And canMoveUp)
					Return GetDistanceToTarget(tile.X,tile.Y-2,targetTile.X,targetTile.Y)
				End
			Case Direction.Down
				If (tile.Y<GridHeight-1 And Grid[0,tile.X,tile.Y+1]=0) 
					Return GetDistanceToTarget(tile.X,tile.Y+2,targetTile.X,targetTile.Y)			
				End
			Case Direction.Left
				If (tile.X>0 And Grid[0,tile.X-1,tile.Y]=0)
					Return GetDistanceToTarget(tile.X-2,tile.Y,targetTile.X,targetTile.Y)	
				End	
			Case Direction.Right
				If (tile.X<GridWidth-1 And Grid[0,tile.X+1,tile.Y]=0) 
					Return GetDistanceToTarget(tile.X+2,tile.Y,targetTile.X,targetTile.Y)	
				End							
		End
		Return -1	
	End
	
	Method GetDistanceToTarget:Int(x1:Int,y1:Int,x2:Int,y2:Int)
		'First will return total tiles (larger), second will return distance
		Return ((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1))
    	'Return (Sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1)))
	End
	
End

Class BlinkyGhostSprite Extends GhostSprite

	Method New(image:string,scatterTargetTile:Vec2f)
		Super.New(image,scatterTargetTile)
		Self.Reset()
	End
	
	Method GetTargetTile:Vec2f() Override
		local targetTile:Vec2f=Yellow.Tile
		Select Self.Mode
			case GhostMode.Scatter
				targetTile=ScatterTargetTile
				
			Case GhostMode.ReturnPen
				targetTile=New Vec2f(14,14)
		End
		Return targetTile
	End
	
	Method Reset() Override
		Self.SetPosition(14,14,0,4)
		Self.SetDirection(Direction.Left)
		Self.Mode=GhostMode.Chase
		Self.SetSpeed()
		Self.DotCounter=0
		Self.ReleaseOnDot=0
	End
	
End

Class PinkyGhostSprite Extends GhostSprite

	Method New(image:string,scatterTargetTile:Vec2f)
		Super.New(image,scatterTargetTile)
		Self.Reset()
	End
	
	Method GetTargetTile:Vec2f() Override
		'Target pacman by default
		local targetTile:Vec2f=Yellow.Tile
		
		'Validate
		select Self.Mode
			Case GhostMode.Chase
				'Target 4 squares directly in front of pacman
				Select Yellow.Dir
					Case Direction.Up
						'Pacman bug - when up also left
						targetTile=New Vec2f(Yellow.Tile.X-4,Yellow.Tile.Y-4)
						'targetTile=New Vec2f(Yellow.Tile.X,Yellow.Tile.Y-4)
					Case Direction.Down
						targetTile=New Vec2f(Yellow.Tile.X,Yellow.Tile.Y+4)
					Case Direction.Left
						targetTile=New Vec2f(Yellow.Tile.X-4,Yellow.Tile.Y)
					Case Direction.Right
						targetTile=New Vec2f(Yellow.Tile.X+4,Yellow.Tile.Y)
				End
				
				'Validate inside grid area
				If(targetTile.X>=GridWidth) targetTile.X=GridWidth-1
				If(targetTile.X<0) targetTile.X=0
				If(targetTile.Y>=GridHeight) targetTile.Y=GridHeight-1
				If(targetTile.Y<0) targetTile.Y=0
								
			case GhostMode.Scatter
				targetTile=ScatterTargetTile
				
			Case GhostMode.ReturnPen
				targetTile=New Vec2f(14,14)
		End
		
		'Return result
		Return targetTile
	End

	Method Reset() Override
		Self.SetPosition(14,17,0,4)
		Self.SetDirection(Direction.Down)
		Self.Mode=GhostMode.Pen
		Self.SetSpeed()
		Self.DotCounter=0
		Self.ReleaseOnDot=0
	End
		
End

Class InkyGhostSprite Extends GhostSprite

	Method New(image:string,scatterTargetTile:Vec2f)
		Super.New(image,scatterTargetTile)
		Self.Reset()
	End
	
	Method GetTargetTile:Vec2f() Override
		'Target pacman by default
		Local targetTile:Vec2f=Yellow.Tile
		
		'Validate
		Select Self.Mode
			Case GhostMode.Chase
				'This is a multi-step process:
				'-Target 2 squares directly in front of pacman
				Select Yellow.Dir
					Case Direction.Up
						'Pacman bug - when up also left
						targetTile=New Vec2f(Yellow.Tile.X-2,Yellow.Tile.Y-2)
						'targetTile=New Vec2f(Yellow.Tile.X,Yellow.Tile.Y-2)
					Case Direction.Down
						targetTile=New Vec2f(Yellow.Tile.X,Yellow.Tile.Y+2)
					Case Direction.Left
						targetTile=New Vec2f(Yellow.Tile.X-2,Yellow.Tile.Y)
					Case Direction.Right
						targetTile=New Vec2f(Yellow.Tile.X+2,Yellow.Tile.Y)
				End
				'-Get distance from Blinkly to target
				Local offsetFromRed:Vec2f=New Vec2f(Red.Tile.X-targetTile.X,Red.Tile.Y-targetTile.Y) 			
				'-Add distance past target	
				targetTile.X+=-offsetFromRed.X
				targetTile.Y+=-offsetFromRed.Y
				
				'Validate inside grid area
				If(targetTile.X>=GridWidth) targetTile.X=GridWidth-1
				If(targetTile.X<0) targetTile.X=0
				If(targetTile.Y>=GridHeight) targetTile.Y=GridHeight-1
				If(targetTile.Y<0) targetTile.Y=0
								
			case GhostMode.Scatter
				targetTile=ScatterTargetTile
				
			Case GhostMode.ReturnPen
				targetTile=New Vec2f(14,14)
		End
		
		'Return result
		Return targetTile	
	End

	Method Reset() Override
		Self.SetPosition(12,17,0,4)
		Self.SetDirection(Direction.Up)
		Self.Mode=GhostMode.Pen
		Self.SetSpeed()
		Self.DotCounter=0
		Self.ReleaseOnDot=0'30
	End
	
End


Class ClydeGhostSprite Extends GhostSprite

	Method New(image:string,scatterTargetTile:Vec2f)
		Super.New(image,scatterTargetTile)
		Self.Reset()
	End
	
	Method GetTargetTile:Vec2f() Override
		'Target pacman by default
		local targetTile:Vec2f=Yellow.Tile
		
		'Validate
		Select Self.Mode
			Case GhostMode.Chase
				'If within 8 tiles of pacman target him otherwise use scatter position
				Local distanceToYellow:Int=GetDistanceToTarget(Self.Tile.X,Self.Tile.Y,Yellow.Tile.X,Yellow.Tile.Y)
				If (distanceToYellow>8) targetTile=ScatterTargetTile
				 				
			case GhostMode.Scatter
				targetTile=ScatterTargetTile
				
			Case GhostMode.ReturnPen
				targetTile=New Vec2f(14,14)
		End
		
		'Return result
		Return targetTile	
	End

	Method Reset() Override
		Self.SetPosition(16,17,0,4)
		Self.SetDirection(Direction.Up)
		Self.Mode=GhostMode.Pen
		Self.SetSpeed()
		Self.DotCounter=0
		Self.ReleaseOnDot=0'60
	End
	
End

Class PacmanSprite Extends Sprite
	Field Score:Int=0
	
	Method New(image:string)
		Super.New(image)
		Self.Reset()
	End

	Method Reset() Override
		Self.SetPosition(14,26,0,4)
		Self.SetDirection(Direction.Left)
		Self.SetSpeed()
		Self.Score=0
	End
			
	Method Update() Override
		'Prepare
		Local isCentreTile:Bool = Self.IsCentreTile(Self.X,Self.Y)
		Local currentTile:Vec2f=Self.Tile
		
		'In tunnel?
		If (isCentreTile And currentTile.X>=GridWidth-1 And Self.Dir=Direction.Right) Self.SetPosition(0,currentTile.Y,0,4)
		If (isCentreTile And currentTile.X<=0 And Self.Dir=Direction.Left) Self.SetPosition(GridWidth-1,currentTile.Y,7,4)
				
		'Validate keys
		Local isKeyUp:Bool=Keyboard.KeyDown(Key.Up)
		Local isKeyDown:Bool=Keyboard.KeyDown(Key.Down)
		Local isKeyLeft:Bool=Keyboard.KeyDown(Key.Left)
		Local isKeyRight:Bool=Keyboard.KeyDown(Key.Right)
		Local isKeysPressed:Bool=(isKeyUp Or isKeyDown Or isKeyLeft Or isKeyRight)

		'Continue? (auto)
		If (Not isKeysPressed And isCentreTile And Not Self.CanMoveDirection(currentTile,Self.Dir)) Return
		
		'Get current position
		Local moveX:Float=Self.X
		Local moveY:Float=Self.Y
		
		'Eat pill?
		If (Grid[2,currentTile.X,currentTile.Y]=1)
			'Collect pill
			Grid[2,currentTile.X,currentTile.Y]=0
			Self.Score+=10
			
			'Pause for this frame when eating pills
			Return
		End
		
		'Change direction? (player)
		If (isKeyDown)
			Local canContinueDown:Bool=Self.CanMoveDirection(currentTile,Direction.Down)
			if (Not isCentreTile And Self.Dir=Direction.Up And canContinueDown)
				'Reverse direction 
				Self.SetDirection(Direction.Down)
			Elseif (isCentreTile And canContinueDown)
				'Change
				Self.SetDirection(Direction.Down)	
			End
		Elseif (isKeyUp)
			Local canContinueUp:Bool=Self.CanMoveDirection(currentTile,Direction.Up)
			if (Not isCentreTile And Self.Dir=Direction.Down And canContinueUp)
				'Reverse direction 
				Self.SetDirection(Direction.Up)
			Elseif (isCentreTile And canContinueUp)
				'Change
				Self.SetDirection(Direction.Up)			
			End 	
		Elseif (isKeyLeft)
			Local canContinueLeft:Bool=Self.CanMoveDirection(currentTile,Direction.Left)
			if (Not isCentreTile And Self.Dir=Direction.Right And canContinueLeft)
				'Reverse direction 
				Self.SetDirection(Direction.Left)
			Elseif (isCentreTile And canContinueLeft)
				'Change
				Self.SetDirection(Direction.Left)			
			End 
		Elseif (isKeyRight)
			Local canContinueRight:Bool=Self.CanMoveDirection(currentTile,Direction.Right)
			if (Not isCentreTile And Self.Dir=Direction.Left And canContinueRight)
				'Reverse direction 
				Self.SetDirection(Direction.Right)
			Elseif (isCentreTile And canContinueRight)
				'Change
				Self.SetDirection(Direction.Right)			
			End 	
		End
		
		'Continue? (player)
		If (isKeysPressed And isCentreTile And Not Self.CanMoveDirection(currentTile,Self.Dir)) Return
		
		'Calc next step
		Select Self.Dir
			Case Direction.Up
				moveY-=Speed
			Case Direction.Left
				moveX-=Speed
			Case Direction.Down
				moveY+=Speed
			Case Direction.Right
				moveX+=Speed
		End
		
		'Update position
		Self.X=moveX
		Self.Y=moveY	
	End

	Method SetSpeed() Override
		'Update
		Self.Speed=0.80	
	End
	
End