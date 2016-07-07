Namespace pacman

'DEV NOTES
'-create a 'game' class to track game-related states such as dot counters and ghost modes
'-frightened mode need to be changed so this mode works inside pen
'-swap modes between scatter and chase
'-global pill collection counter (utilised after first death)
'-die when touching ghosts

'Sprites
#Import "../images/pacman.png"
#Import "../images/blinky.png"
#Import "../images/pinky.png"
#Import "../images/clyde.png"
#Import "../images/inky.png"
#Import "../images/eyes.png"
#Import "../images/frightened.png"

Global Sprites:=New Stack<Sprite> ' Contains all the sprites displayed on the screen
Global Pacman:PacmanSprite
Global Blinky:BlinkyGhostSprite
Global Pinky:PinkyGhostSprite
Global Clyde:ClydeGhostSprite
Global Inky:InkyGhostSprite
Global Eyes:ImageCollection
Global Frightened:ImageCollection

Enum Direction
	Up
	Left
	Down
	Right
End

Enum GhostMode
    Pen
    LeaveCentrePen
    LeavePen
	ReturnPen
	ReturnCentrePen
	ReturnHomePen
	Chase
	Scatter
	Frightened
End

Function InitialiseSprites()
	'Images
	Eyes=New ImageCollection("asset::eyes.png",16,16)
	Frightened=New ImageCollection("asset::frightened.png",16,16)
	'Sprites
	Pacman=New PacmanSprite("asset::pacman.png")
	Blinky=New BlinkyGhostSprite("asset::blinky.png")
	Pinky=New PinkyGhostSprite("asset::pinky.png")
	Clyde=New ClydeGhostSprite("asset::clyde.png")
	Inky=New InkyGhostSprite("asset::inky.png")
	
	'Testing (outside pen)
	'Pinky.SetPosition(14,14)
	'Pinky.Mode=GhostMode.Chase
	'Pinky.SetDirection(Direction.Left)
	'Pinky.NextDir=Direction.Left
	'Clyde.SetPosition(14,14)
	'Clyde.Mode=GhostMode.Chase
	'Clyde.SetDirection(Direction.Left)
	'Clyde.NextDir=Direction.Left
	'Inky.SetPosition(14,14)
	'Inky.Mode=GhostMode.Chase
	'Inky.SetDirection(Direction.Left)
	'Inky.NextDir=Direction.Left
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
		If (ghost<>Null) 
			'Update
			Select ghost.Mode
				Case GhostMode.Chase,GhostMode.Scatter,GhostMode.Frightened
					'Reverse? (unless currently frightened)
					ghost.ReverseDirection=(ghost.Mode<>GhostMode.Frightened)
					ghost.Mode=mode
			End

		End
	Next
End

Function ActivateGhostPillCounter(currentGhost:GhostSprite)
	'Prepare
	Local nextGhost:GhostSprite=Null
	
	'Validate
	If (currentGhost=Blinky) nextGhost=Pinky
	If (currentGhost=Pinky) nextGhost=Inky
	If (currentGhost=Inky) nextGhost=Clyde
	
	'Activate?
	currentGhost.PillCounterActive=False
	If (nextGhost<>Null) nextGhost.PillCounterActive=True
End

Function IncrementPillCounter()
	Pacman.PillsCollected+=1
	If (Blinky.PillCounterActive) Blinky.PillCounter+=1
	If (Pinky.PillCounterActive) Pinky.PillCounter+=1
	If (Inky.PillCounterActive) Inky.PillCounter+=1
	If (Clyde.PillCounterActive) Clyde.PillCounter+=1
End

Function SetSpriteSpeed:Void()
	For Local i:=0 Until Sprites.Length
		Sprites[i].SetSpeed()				
	Next
	
End

Function WrapMod:Int(a:Int,n:Int)
	Local result:Int = (a Mod n)
	If (result<0) result+=n
	Return result
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
	Field Speed:Float=1.0
	Field StartTile:=New Vec2i(0,0)
	Field HomeTile:=New Vec2i(0,0)
	
	Method New(asset:string)
		' Prepare
		Self.Images=New ImageCollection(asset,16,16)		
			
		' Store
		Sprites.Push(Self)
	End
	
	Property Tile:Vec2i()
		Return New Vec2i(Int(Self.X/8),Int(Self.Y/8))
	End
		
	Method Reset() Abstract
	
	Method SetSpeed() Abstract
	
	Method Update() Virtual
		'Validate speed
		Self.SetSpeed()

		'Update position
		Select Self.Dir
			Case Direction.Up
				Self.Y-=Speed
			Case Direction.Left
				Self.X-=Speed
			Case Direction.Down
				Self.Y+=Speed
			Case Direction.Right
				Self.X+=Speed
		End
	End

	Method GetAnimation:ImageCollection() Virtual
		Return Self.Images
	End	
	
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
		Local images:ImageCollection=Self.GetAnimation()
		' Validate
		If (frame=-1) frame=Self.Frame
		If (flip) scale=New Vec2f(-1,1)
		
		' Draw
		canvas.BlendMode=Self.Blend
		canvas.Color=Self.Color
		canvas.DrawImage(images.Item[frame],position,Self.Rotation,scale)
	End
		
	Method SetPosition(x:Int,y:Int,offsetX:Int=4,offsetY:Int=4)
		SetPosition(New Vec2i(x,y),offsetX,offsetY)
	End	
	Method SetPosition(tile:Vec2i,offsetX:Int=4,offsetY:Int=4)
		Self.X=(tile.X*8)+offsetX
		Self.Y=(tile.Y*8)+offsetY
	End
				
	Method IsCentreTile:Bool(x:Float,y:Float,xOffset:Int=4,yOffset:Int=4) Virtual
		Return ((Int(x) Mod 8)=xOffset And (Int(y) Mod 8)=yOffset)
	End
	
	Method GetNewDirection:Int(tile:Vec2i)
		'Validate
		If (Grid[0,tile.X,tile.Y-1]=0 And Self.Dir<>Direction.Down)
			Return Direction.Up
		Elseif(Grid[0,tile.X-1,tile.Y]=0 And Self.Dir<>Direction.Right)
			Return Direction.Left
		Elseif(Grid[0,tile.X,tile.Y+1]=0 And Self.Dir<>Direction.Up)
			Return Direction.Down
		End
		Return Direction.Right
	End
		
	Method CanMoveDirection:Bool(tile:Vec2i,moveDir:Int)
		tile=GetTile(tile,moveDir)
		'If (moveDir=Direction.Up And Grid[0,tile.X,tile.Y]=44) Return True
		Return (Grid[0,tile.X,tile.Y]=0) 					
	End
	
	Method GetTile:Vec2i(tile:Vec2i,dir:Int)
		'Adjust search block (wrap as required)
		'Note: Built-in Mod doesn't handle negative wrap
		Select dir
			Case Direction.Up
				tile.Y=WrapMod(tile.Y-1,GridHeight)
				'tile.Y=(tile.Y-1) Mod GridHeight
			Case Direction.Down
				tile.Y=WrapMod(tile.Y+1,GridHeight)
				'tile.Y=(tile.Y+1) Mod GridHeight
			Case Direction.Left
				tile.X=WrapMod(tile.X-1,GridWidth)
				'tile.X=(tile.X-1) Mod GridWidth
			Case Direction.Right
				tile.X=WrapMod(tile.X+1,GridWidth)
				'tile.X=(tile.X+1) Mod GridWidth
		End
		Return tile	
	End
	
End

Class GhostSprite Extends Sprite
	Field NextDir:Int=Direction.Up
	Field PrevDir:Int=0
	Field PrevTile:=New Vec2i(0,0)
	Field ScatterTile:=New Vec2i(0,0)
	Field Mode:Int=GhostMode.Chase
	Field ReverseDirection:Bool=False
	Field PillCounter:Int=0
	Field ReleaseOnPill:Int=0
	Field PillCounterActive:Bool=False
	
	Method New(asset:string)
		Super.New(asset)
	End
		
	Method GetTargetTile:Vec2i() Virtual
		'Target pacman by default
		local targetTile:Vec2i=Pacman.Tile
		select Self.Mode
			Case GhostMode.LeavePen,GhostMode.ReturnPen
				targetTile=New Vec2i(14,14)		
			Case GhostMode.LeaveCentrePen
				targetTile=New Vec2i(14,17)
			Case GhostMode.ReturnCentrePen
				targetTile=New Vec2i(14,18)
			Case GhostMode.ReturnHomePen
				targetTile=Self.HomeTile			
			Case GhostMode.Frightened
				targetTile=Self.ScatterTile
		End
		Return targetTile
	End

	Method SetSpeed() Override
		'Validate
		Select Self.Mode
			Case GhostMode.Pen
				Self.Speed=0.75
			Case GhostMode.LeaveCentrePen,GhostMode.LeavePen,GhostMode.ReturnCentrePen,GhostMode.ReturnHomePen
				Self.Speed=0.75
			Case GhostMode.Frightened
				Self.Speed=0.50
			Case GhostMode.ReturnPen
				Self.Speed=1.00
				Return
			Default
				Self.Speed=0.75	
		End
		
		'In tunnel?
		If (Self.Tile.X<=0 Or Self.Tile.X>=GridWidth)
			Self.Speed=0.40
		Elseif (Grid[1,Self.Tile.X,Self.Tile.Y]=1) 
			Self.Speed=0.40
		End
	End
	
	Method SetDirection(dir:Int)
		Self.PrevDir=Self.Dir
		Self.Dir=dir
		Self.NextDir=dir
	End
	
	Method GetAnimation:ImageCollection() Override
		Select Self.Mode
			Case GhostMode.Frightened
				Return Frightened
			Case GhostMode.ReturnPen,GhostMode.ReturnCentrePen,GhostMode.ReturnHomePen
				Return Eyes
		End
		Return Super.GetAnimation()
	End
	
	Method IsCentreTile:Bool(x:Float,y:Float,xOffset:Int=4,yOffset:Int=4) Override
		'Validate (make sure we have left last tile before next check)
		Select Self.Mode
			Case GhostMode.Pen
				'Do nothing
			Default
				Local currentTile:=New Vec2i(Int(x/8),Int(y/8))
				If (currentTile.X=Self.PrevTile.X And currentTile.Y=Self.PrevTile.Y) Return False
		End
		Return Super.IsCentreTile(x,y,xOffset,yOffset)
	End
	
	Method Update() Override
		'Debugging
		If (Not window.MoveGhosts) return
				
		'Repeat (speed up return to pen)
		Local updateIndex:Int=1
		If(Self.Mode=GhostMode.ReturnPen) updateIndex=2
		
		'Process
		For Local index:Int=0 Until updateIndex
			'Determine required IsCentreTile xTileOffset
			'Allows us to utilise the existing tile system inside the pen
			Local xTileOffset:Int=4
			Local yTileOffset:Int=4
			Select Self.Mode
				Case GhostMode.Pen
					xTileOffset=0
				'	If (Self.Dir=Direction.Up) yTileOffset=7
				'	If (Self.Dir=Direction.Down) yTileOffset=0
					
				Case GhostMode.LeaveCentrePen,GhostMode.LeavePen
					xTileOffset=0
					
				Case GhostMode.ReturnPen
					'Wait until we reach entry position
					Local returnTile:=Self.GetTargetTile()
					If (Self.Tile.X=returnTile.X And Self.Tile.Y=returnTile.Y) xTileOffset=0
					
				Case GhostMode.ReturnCentrePen,GhostMode.ReturnHomePen
					'Get to bottom of pen
					xTileOffset=0
					yTileOffset=0
			End
			
			'Update position (dynamic)
			Select Self.Mode
				Case GhostMode.Pen
					'Reverse dir? (we need to change direction as soon as we enter required tile)
					If (Self.Tile.Y<>17) Self.SetDirection((Self.Dir+2) Mod 4)						
			End

			'Is in tunnel?
			If (Self.Tile.X>GridWidth And Self.Dir=Direction.Right)
				'Swap to left
				Self.SetPosition(-1,Self.Tile.Y,0,4)			
			Elseif (Self.Tile.X<0 And Self.Dir=Direction.Left)
				'Swap to right 
				Self.SetPosition(GridWidth,Self.Tile.Y,7,4)			
			End	
	
			'Update position (tile)
			Local isCentreTile:bool=Self.IsCentreTile(Self.X,Self.Y,xTileOffset,yTileOffset)
			If (isCentreTile)	
				'Update direction?
				Select Self.Mode
					Case GhostMode.Pen	
						'Do nothing	(this mode is using Dir not NextDir)							
					Default
						'Set
						Self.SetDirection(Self.NextDir)	
						Self.PrevTile=Self.Tile			
				End
													
				'Set next direction
				Select Self.Mode
					Case GhostMode.Pen	
						'Ready to leave?					
						If (Self.PillCounter>=Self.ReleaseOnPill And Self.Dir=Direction.Up)
							'Set
							Self.Mode=GhostMode.LeaveCentrePen
							ActivateGhostPillCounter(Self)
							
							'Validate (in LeaveCentrePen tile?)
							Local targetTile:=Self.GetTargetTile()
							If (Self.Tile.X=targetTile.X And Self.Tile.Y=targetTile.Y) Self.Mode=GhostMode.LeavePen
							Self.SetDirection(Self.GetPenTargetDir(Self.Tile))	
						End If
	
					Case GhostMode.LeaveCentrePen,GhostMode.LeavePen
						'Validate
						Local targetTile:=Self.GetTargetTile()
						If (Self.Tile.X=targetTile.X And Self.Tile.Y=targetTile.Y)
							If (Self.Mode=GhostMode.LeavePen)
								'Exited
								Self.Mode=GhostMode.Scatter
								Self.SetDirection(Direction.Left)
								'Reverse?
								If (Self.ReverseDirection) 
									Self.NextDir=(Self.NextDir+2) Mod 4	
									Self.ReverseDirection=False					
								End
							Else
								'Leave
								Self.Mode=GhostMode.LeavePen
								Self.SetDirection(Self.GetPenTargetDir(Self.Tile))
							End				
						End
	
					Case GhostMode.ReturnPen
						'Validate if returned to entry
						Local targetTile:=Self.GetTargetTile()
						If (Self.Tile.X=targetTile.X And Self.Tile.Y=targetTile.Y)
							'Enter
							Self.Mode=GhostMode.ReturnCentrePen
							Self.SetDirection(Self.GetPenTargetDir(Self.Tile))	
						Else
							'Return to entry
							Self.NextDir=Self.GetTargetDir()				
						End
						
					Case GhostMode.ReturnCentrePen,GhostMode.ReturnHomePen
						Local targetTile:=Self.GetTargetTile()
						If (Self.Tile.X=targetTile.X And Self.Tile.Y=targetTile.Y)
							'Set
							Self.Mode=GhostMode.ReturnHomePen
	
							'Validate
							If (Self.Tile.X=Self.HomeTile.X And Self.Tile.Y=Self.HomeTile.Y)
								'Arrived
								Self.Mode=GhostMode.Pen
								Self.SetDirection(Direction.Up)
							Else
								'Return
								Self.SetDirection(Self.GetPenTargetDir(Self.Tile))
							End
						End								
									
					Default	
						'Reverse direction?
						If (Self.ReverseDirection)
							'Validate (if in corner a straight reverse may not work)
							Local reverseDir:Int=(Self.Dir+2) Mod 4
							If (Not Self.CanMoveDirection(Self.Tile,reverseDir)) reverseDir=(Self.PrevDir+2) Mod 4
							
							'Update
							Self.SetDirection(reverseDir)
							Self.ReverseDirection=False
						End
												
						'Set new direction and tile
						Select Self.Mode
							Case GhostMode.Chase,GhostMode.Scatter
								'Set
								Self.NextDir=GetTargetDir()
	
							Case GhostMode.Frightened
								'NOT WORKING CURRENTLY
								'Self.NextDir=Self.GetNewDirection(Self.Tile)
								
								'Note: There is a pseudo-random (PRNG) number to determine direction
								'      if it cannot move in that direction then choose a direction
								'      as follows: up,left,down,right
								'Note: Need to make sure we don't return from existing direction 
	
								'TODO: Implement above
								Self.NextDir=GetTargetDir()
						End	
				End					
			End
	
			'Update position
			Super.Update()
			
			'Collision
			If (Self.Tile.X=Pacman.Tile.X And Self.Tile.Y=Pacman.Tile.Y)
				'Temp: Return to pen
				Self.Mode=GhostMode.ReturnPen
				Pacman.Score+=50
			End
			
		End
		
	End
	
	Method Render(canvas:Canvas) Override
		Super.Render(canvas)
		
		'Debugging?
		If (window.IsDebug)	
			'Draw line to target
			Select Self.Mode
				Case GhostMode.Pen
					'No nothing
				Default
					'Target
					Local targetTile:=GetTargetTile()
					canvas.Color=Color.Green
					canvas.DrawLine(DisplayOffset.X+(Self.Tile.X*8)+4,DisplayOffset.Y+(Self.Tile.Y*8)+4,DisplayOffset.X+(targetTile.X*8)+4,DisplayOffset.Y+(targetTile.Y*8)+4)
			End	
		End	
	End
			
Private
	Method FindTargetDistance:Int(tile:Vec2i,targetTile:Vec2i,dirToTarget:Int)	
		tile=Self.GetTile(tile,dirToTarget)
		Return GetDistanceToTarget(tile,targetTile)
	End
		
	Method GetDistanceToTarget:Int(tile:Vec2i,targetTile:Vec2i)
		Local d:=New Vec2i(tile.X-targetTile.X,tile.Y-targetTile.Y)
		Return (d.X*d.X+d.Y*d.y)
	End
	
	Method GetPenTargetDir:Int(tile:Vec2i)
		Local targetTile:=Self.GetTargetTile()
		If (targetTile.X<tile.X) Return Direction.Left
		If (targetTile.X>tile.X) Return Direction.Right
		'If (targetTile.Y<tile.Y) Return Direction.Up
		If (targetTile.Y>tile.Y) Return Direction.Down
		Return Direction.Up
	End
	
	Method GetTargetDir:Int()
		'Prepare
		Local nextTile:=Self.GetTile(Self.Tile,Self.NextDir)
		Local targetTile:Vec2i=Self.GetTargetTile()
		Local excludeDir:Int=(Self.Dir+2) Mod 4
		Local targetDir:Int=-1
		Local targetDistance:Int=-1

		'Validate (special zones where ghost cannot move up)
		Local canMoveUp:Bool=True
		Select Self.Mode
			Case GhostMode.Chase,GhostMode.Scatter
				If (Grid[1,nextTile.X,nextTile.Y]=2) canMoveUp=False
		End
							
		'Validate (determine best available direction [order Up, Left, Down, Right])
		For Local dir:Int=0 To 3
			'Validate (special zone or direction coming from)
			If ((dir=Direction.Up And Not canMoveUp) Or dir=excludeDir) Continue
								
			'Validate
			If (Self.CanMoveDirection(nextTile,dir))
				Local checkTargetDistance:Int=Self.FindTargetDistance(nextTile,targetTile,dir)
				If (checkTargetDistance>=0 And (checkTargetDistance<targetDistance Or targetDistance<0))
					'Store best available
					targetDistance=checkTargetDistance
					targetDir=dir
				End
			End
		Next	
		
		'Return result
		Return targetDir
	End
			
End

Class BlinkyGhostSprite Extends GhostSprite

	Method New(imagePath:string)
		Super.New(imagePath)
		Self.Reset()
	End

	Method Reset() Override
		Self.StartTile=New Vec2i(14,14)
		Self.HomeTile=New Vec2i(14,18)
		Self.ScatterTile=New Vec2i(25,0)
		Self.SetPosition(Self.StartTile,0,4)
		Self.Dir=Direction.Left
		Self.NextDir=Self.Dir
		Self.Mode=GhostMode.Scatter
		Self.PillCounter=0
		Self.ReleaseOnPill=0
	End
	
	Method GetTargetTile:Vec2i() Override
		'Find
		local targetTile:Vec2i=Super.GetTargetTile()
		Select Self.Mode
			case GhostMode.Scatter
				targetTile=ScatterTile
		End
		Return targetTile
	End
		
End

Class PinkyGhostSprite Extends GhostSprite

	Method New(image:string)
		Super.New(image)
		Self.Reset()
	End

	Method Reset() Override
		Self.StartTile=New Vec2i(14,17)
		Self.HomeTile=New Vec2i(14,18)
		Self.ScatterTile=New Vec2i(2,0)
		Self.SetPosition(Self.StartTile,0,4)
		Self.Dir=Direction.Down
		Self.NextDir=Self.Dir
		Self.Mode=GhostMode.Pen
		Self.PillCounter=0
		Self.ReleaseOnPill=0
		Self.PillCounterActive=True
	End
	
	Method GetTargetTile:Vec2i() Override
		'Find
		Local targetTile:Vec2i=Super.GetTargetTile()
		Select Self.Mode
			Case GhostMode.Chase
				'Target 4 squares directly in front of pacman
				Select Pacman.Dir
					Case Direction.Up
						'Pacman bug - when up also left
						targetTile=New Vec2i(Pacman.Tile.X-4,Pacman.Tile.Y-4)
						'targetTile=New Vec2i(Pacman.Tile.X,Yellow.Tile.Y-4)
					Case Direction.Down
						targetTile=New Vec2i(Pacman.Tile.X,Pacman.Tile.Y+4)
					Case Direction.Left
						targetTile=New Vec2i(Pacman.Tile.X-4,Pacman.Tile.Y)
					Case Direction.Right
						targetTile=New Vec2i(Pacman.Tile.X+4,Pacman.Tile.Y)
				End
				
				'Validate inside grid area
				If(targetTile.X>=GridWidth) targetTile.X=GridWidth
				If(targetTile.X<0) targetTile.X=0
				If(targetTile.Y>=GridHeight) targetTile.Y=GridHeight
				If(targetTile.Y<0) targetTile.Y=0								
			Case GhostMode.Scatter
				targetTile=ScatterTile				
		End
		Return targetTile
	End
			
End

Class InkyGhostSprite Extends GhostSprite

	Method New(asset:String)
		Super.New(asset)
		Self.Reset()
	End

	Method Reset() Override
		Self.StartTile=New Vec2i(12,17)
		Self.HomeTile=New Vec2i(12,18)
		Self.ScatterTile=New Vec2i(27,35)
		Self.SetPosition(Self.StartTile,0,4)
		Self.Dir=Direction.Up
		Self.NextDir=Self.Dir
		Self.Mode=GhostMode.Pen
		Self.PillCounter=0
		Self.ReleaseOnPill=30
	End
	
	Method GetTargetTile:Vec2i() Override
		'Find
		Local targetTile:Vec2i=Super.GetTargetTile()
		Select Self.Mode
			Case GhostMode.Chase
				'This is a multi-step process:
				'-Target 2 squares directly in front of pacman
				Select Pacman.Dir
					Case Direction.Up
						'Pacman bug - when up also left
						targetTile=New Vec2i(Pacman.Tile.X-2,Pacman.Tile.Y-2)
						'targetTile=New Vec2i(Pacman.Tile.X,Pacman.Tile.Y-2)
					Case Direction.Down
						targetTile=New Vec2i(Pacman.Tile.X,Pacman.Tile.Y+2)
					Case Direction.Left
						targetTile=New Vec2i(Pacman.Tile.X-2,Pacman.Tile.Y)
					Case Direction.Right
						targetTile=New Vec2i(Pacman.Tile.X+2,Pacman.Tile.Y)
				End
				'-Get distance from Blinkly to target
				Local offsetFromBlinky:Vec2i=New Vec2i(Blinky.Tile.X-targetTile.X,Blinky.Tile.Y-targetTile.Y) 			
				'-Add distance past target	
				targetTile.X+=-offsetFromBlinky.X
				targetTile.Y+=-offsetFromBlinky.Y
				
				'Validate inside grid area
				If(targetTile.X>=GridWidth) targetTile.X=GridWidth-1
				If(targetTile.X<0) targetTile.X=0
				If(targetTile.Y>=GridHeight) targetTile.Y=GridHeight-1
				If(targetTile.Y<0) targetTile.Y=0
											
			case GhostMode.Scatter
				targetTile=ScatterTile			
		End
		Return targetTile	
	End
	
End

Class ClydeGhostSprite Extends GhostSprite

	Method New(asset:string)
		Super.New(asset)
		Self.Reset()
	End

	Method Reset() Override
		Self.StartTile=New Vec2i(16,17)
		Self.HomeTile=New Vec2i(16,18)
		Self.ScatterTile=New Vec2i(0,35)
		Self.SetPosition(Self.StartTile,0,4)
		Self.Dir=Direction.Up
		Self.NextDir=Self.Dir
		Self.Mode=GhostMode.Pen
		Self.PillCounter=0
		Self.ReleaseOnPill=60
	End
		
	Method GetTargetTile:Vec2i() Override
		'Find
		Local targetTile:Vec2i=Super.GetTargetTile()
		Select Self.Mode
			Case GhostMode.Chase
				'If within 8 tiles of pacman target him otherwise use scatter position
				Local distanceToPacman:Int=Sqrt(Self.GetDistanceToTarget(Self.Tile,Pacman.Tile))
				If (distanceToPacman>8) targetTile=ScatterTile				 				
			case GhostMode.Scatter
				targetTile=ScatterTile				
		End
		Return targetTile	
	End

End

Class PacmanSprite Extends Sprite
	Field Score:Int=0
	Field PillsCollected:Int=0
	Field PauseFrame:Int=0
	
	Method New(image:string)
		Super.New(image)
		Self.Reset()
	End

	Method Reset() Override
		Self.StartTile=New Vec2i(14,26)
		Self.HomeTile=Self.StartTile
		Self.SetPosition(Self.StartTile,0,4)
		Self.Dir=Direction.Left
	End
			
	Method Update() Override
		'Pause?
		If (Self.PauseFrame>0)
			Self.PauseFrame-=1
			Return
		End
		
		'Prepare
		Local isCentreTile:Bool = Self.IsCentreTile(Self.X,Self.Y)
		Local currentTile:Vec2i=Self.Tile
		
		'In tunnel?
		If (currentTile.X>GridWidth And Self.Dir=Direction.Right) Self.SetPosition(-1,currentTile.Y,0,4)
		If (currentTile.X<0 And Self.Dir=Direction.Left) Self.SetPosition(GridWidth,currentTile.Y,7,4)
				
		'Validate keys
		Local isKeyUp:Bool=Keyboard.KeyDown(Key.Up)
		Local isKeyDown:Bool=Keyboard.KeyDown(Key.Down)
		Local isKeyLeft:Bool=Keyboard.KeyDown(Key.Left)
		Local isKeyRight:Bool=Keyboard.KeyDown(Key.Right)
		Local isKeysPressed:Bool=(isKeyUp Or isKeyDown Or isKeyLeft Or isKeyRight)

		'Continue? (auto)
		If (Not isKeysPressed And isCentreTile And Not Self.CanMoveDirection(currentTile,Self.Dir)) Return
				
		'Anything to eat?
		If (currentTile.X>0 And currentTile.X<GridWidth)
			If (Grid[2,currentTile.X,currentTile.Y]=1)
				'Pill (block 1)
				Grid[2,currentTile.X,currentTile.Y]=0
				Self.Score+=10
				IncrementPillCounter()
				'Pause for 1 frame (this one) when eating pills
				Return
			Elseif (Grid[2,currentTile.X,currentTile.Y]>=2)
				'Energizer (block 2-3)
				Grid[2,currentTile.X,currentTile.Y]=0
				Self.Score+=50
				'Activate frightened mode
				SetGhostMode(GhostMode.Frightened)
				'Pause for 3 frames (this one plus 2 others) when eating energizers
				Self.PauseFrame=2
				Return
			End
		End
		
		'Change direction?
		If (isKeyDown)
			Local canContinueDown:Bool=Self.CanMoveDirection(currentTile,Direction.Down)
			if (Not isCentreTile And Self.Dir=Direction.Up And canContinueDown)
				'Reverse direction 
				Self.Dir=Direction.Down
			Elseif (isCentreTile And canContinueDown)
				'Change
				Self.Dir=Direction.Down	
			End
		Elseif (isKeyUp)
			Local canContinueUp:Bool=Self.CanMoveDirection(currentTile,Direction.Up)
			if (Not isCentreTile And Self.Dir=Direction.Down And canContinueUp)
				'Reverse direction 
				Self.Dir=Direction.Up
			Elseif (isCentreTile And canContinueUp)
				'Change
				Self.Dir=Direction.Up			
			End 	
		Elseif (isKeyLeft)
			Local canContinueLeft:Bool=Self.CanMoveDirection(currentTile,Direction.Left)
			if (Not isCentreTile And Self.Dir=Direction.Right And canContinueLeft)
				'Reverse direction 
				Self.Dir=Direction.Left
			Elseif (isCentreTile And canContinueLeft)
				'Change
				Self.Dir=Direction.Left
			End 
		Elseif (isKeyRight)
			Local canContinueRight:Bool=Self.CanMoveDirection(currentTile,Direction.Right)
			if (Not isCentreTile And Self.Dir=Direction.Left And canContinueRight)
				'Reverse direction 
				Self.Dir=Direction.Right
			Elseif (isCentreTile And canContinueRight)
				'Change
				Self.Dir=Direction.Right
			End 	
		End
		
		'Continue? (player)
		If (isKeysPressed And isCentreTile And Not Self.CanMoveDirection(currentTile,Self.Dir)) Return
		
		'Update position
		Super.Update()
	End

	Method SetSpeed() Override
		'Update
		Self.Speed=0.80	
	End
	
End