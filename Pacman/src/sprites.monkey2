Namespace pacman

'DEV NOTES
'-update ghost movement to determine next move from prior tile and store for use on next 'Centering'
'-Allow objects to exit 'offscreen' before flipping when in tunnels
'-create a 'game' class to track game-related states such as dot counters and ghost modes

'Sprites
#Import "../images/yellow.png"
#Import "../images/blinky.png"
#Import "../images/pinky.png"
#Import "../images/clyde.png"
#Import "../images/inky.png"

Global Sprites:=New Stack<Sprite> ' Contains all the sprites displayed on the screen
Global Pacman:PacmanSprite
Global Blinky:BlinkyGhostSprite
Global Pinky:PinkyGhostSprite
Global Clyde:ClydeGhostSprite
Global Inky:InkyGhostSprite

Global DotCounter:Int=0

Enum Direction
	Up
	Left
	Down
	Right
End

Enum GhostMode
    Pen
    PrepareLeavePen
    LeavePen
	ReturnPen
	EnterPen
	Chase
	Scatter
	Frightened
End

Function InitialiseSprites()
	'Sprites
	Pacman=New PacmanSprite("asset::yellow.png")
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
	DotCounter+=1
	
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
		If (moveDir=Direction.Up And Grid[0,tile.X,tile.Y]=44) Return True
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
	Field PrevTile:=New Vec2i(0,0)
	Field ScatterTargetTile:=New Vec2i(0,0)
	Field Mode:Int=GhostMode.Chase
	Field ReverseDirection:Bool=False
	Field ExitPenDir:Int=Direction.Left
	Field DotCounter:Int=0
	Field ReleaseOnDot:Int=0
	Field DotCounterActive:Bool=False
	
	Method New(asset:string)
		Super.New(asset)
	End
		
	Method GetTargetTile:Vec2i() Virtual
		'Target pacman by default
		local targetTile:Vec2i=Pacman.Tile
		select Self.Mode
			Case GhostMode.LeavePen,GhostMode.ReturnPen
				targetTile=New Vec2i(14,14)		
			Case GhostMode.PrepareLeavePen
				targetTile=New Vec2i(14,17)			
		End
		Return targetTile
	End

	Method SetSpeed() Override
		'Validate
		Select Self.Mode
			Case GhostMode.Pen,GhostMode.PrepareLeavePen,GhostMode.LeavePen
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
		If (Grid[1,Self.Tile.X,Self.Tile.Y]=1) Self.Speed=0.40
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
		
		'Increment
		Self.DotCounter+=1

		'Determine required IsCentreTile xTileOffset
		'Allows use to utilise the existing tile system inside the Pen
		Local xTileOffset:Int=4
		Local yTileOffset:Int=4
		Select Self.Mode
			Case GhostMode.Pen,GhostMode.PrepareLeavePen,GhostMode.LeavePen,GhostMode.EnterPen
				xTileOffset=0
				
			Case GhostMode.ReturnPen
				'Wait until we reach entry position
				Local returnTile:=Self.GetTargetTile()
				If (Self.Tile.X=returnTile.X And Self.Tile.Y=returnTile.Y) xTileOffset=0
		End
		
		'Update pen position (changes direction as soon as we enter required tile)
		Select Self.Mode
			Case GhostMode.Pen
				'Reverse dir?
				If (Self.Tile.Y<>17) Self.Dir=(Self.Dir+2) Mod 4						
		End

		'Check for centre of tile
		Local isCentreTile:bool=Self.IsCentreTile(Self.X,Self.Y,xTileOffset,yTileOffset)
		If (isCentreTile)	
			'Update direction?
			Select Self.Mode
				Case GhostMode.Pen	
					'Do nothing	(this mode is using Dir not NextDir)							
				Default
					'Set
					Self.Dir=Self.NextDir	
					Self.PrevTile=Self.Tile			
			End
						
			'Is in tunnel?
			'TODO: need to allow object to exit 'offscreen' before flipping
			If (Self.Tile.X>=GridWidth-1 And Self.Dir=Direction.Right)
				'Move to left
				Self.SetPosition(0,Self.Tile.Y,0,4)			
			Elseif (Self.Tile.X<=0 And Self.Dir=Direction.Left)
				'Move to right 
				Self.SetPosition(GridWidth-1,Self.Tile.Y,7,4)			
			End	

			'Set next direction
			Select Self.Mode
				Case GhostMode.Pen					
					'Ready to leave?					
					If (Self.DotCounter>=Self.ReleaseOnDot And Self.Dir=Direction.Up)
						'Set
						Self.Mode=GhostMode.PrepareLeavePen
						Self.Dir=Self.GetTargetDir()
						Self.NextDir=Self.Dir						
					End If

				Case GhostMode.PrepareLeavePen,GhostMode.LeavePen
					'Validate
					Local targetTile:=Self.GetTargetTile()
					If (Self.Tile.X=targetTile.X And Self.Tile.Y=targetTile.Y)
						'Validate
						If (Self.Mode=GhostMode.LeavePen)
							'Left pen
							Self.Dir=Direction.Left
							Self.NextDir=Self.ExitPenDir
							Self.Mode=GhostMode.Chase
						Else
							'Leave
							Self.NextDir=Direction.Up
							Self.Mode=GhostMode.LeavePen	
						End											
					Else
						'Move to centre					
						Self.NextDir=GetTargetDir()					
					End
													
				Case GhostMode.ReturnPen
					'Temp
					Self.NextDir=GetTargetDir()
					
					'NOT WORKING CURRENTLY
					'Validate if returned to entry
					'Local targetTile:=Self.GetTargetTile()
					'If (Self.Tile.X=targetTile.X And Self.Tile.Y=targetTile.Y)
					'	'Enter pen
					'	Self.Mode=GhostMode.EnterPen
					'	Self.Dir=Direction.Down
					'	Self.PrevTile=Self.Tile		
					'Else
					'	'Set
					'	Self.NextDir=GetTargetDir()				
					'End
					
				Case GhostMode.EnterPen
					'NOT WORKING CURRENTLY
					
					'Arrived
					'If (Self.Tile.Y=17)
					'	Self.Mode=GhostMode.Pen
					'	Self.Dir=Direction.Down
					'	Self.DotCounter=0
					'End
					
				Default	
					'Set new direction and tile
					Select Self.Mode
						Case GhostMode.Chase,GhostMode.Scatter
							'Set
							Self.NextDir=GetTargetDir()

						Case GhostMode.Frightened
							'NOT WORKING CURRENTLY
							
							'Note: There is a pseudo-random (PRNG) number to determine direction
							'      if it cannot move in that direction then choose a direction
							'      as follows: up,left,down,right
							'Note: Need to make sure we don't return from existing direction 

							'TODO: Implement above
							Self.NextDir=Self.GetNewDirection(Self.Tile)
							'Self.SetDirection(Self.GetNewDirection(currentTile))
					End		
			End					
		End

		'Update position
		Super.Update()

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
		Self.HomeTile=New Vec2i(14,14)
		Self.SetPosition(Self.HomeTile,0,4)
		Self.ScatterTargetTile=New Vec2i(25,0)
		Self.Dir=Direction.Left
		Self.NextDir=Self.Dir
		Self.Mode=GhostMode.Chase
		Self.SetSpeed()
		Self.DotCounter=0
		Self.ReleaseOnDot=0
	End
	
	Method GetTargetTile:Vec2i() Override
		'Find
		local targetTile:Vec2i=Super.GetTargetTile()
		Select Self.Mode
			case GhostMode.Scatter
				targetTile=ScatterTargetTile
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
		Self.HomeTile=New Vec2i(14,17)
		Self.ScatterTargetTile=New Vec2i(2,0)
		Self.SetPosition(Self.HomeTile,0,4)
		Self.Dir=Direction.Down
		Self.NextDir=Self.Dir
		Self.Mode=GhostMode.Pen
		Self.SetSpeed()
		Self.DotCounter=0
		Self.ReleaseOnDot=0
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
				If(targetTile.X>=GridWidth) targetTile.X=GridWidth-1
				If(targetTile.X<0) targetTile.X=0
				If(targetTile.Y>=GridHeight) targetTile.Y=GridHeight-1
				If(targetTile.Y<0) targetTile.Y=0								
			Case GhostMode.Scatter
				targetTile=ScatterTargetTile				
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
		Self.HomeTile=New Vec2i(12,17)
		Self.ScatterTargetTile=New Vec2i(27,35)
		Self.SetPosition(Self.HomeTile,0,4)
		Self.Dir=Direction.Up
		Self.NextDir=Self.Dir
		Self.Mode=GhostMode.Pen
		Self.SetSpeed()
		Self.DotCounter=0
		Self.ReleaseOnDot=100
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
				targetTile=ScatterTargetTile			
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
		Self.HomeTile=New Vec2i(16,17)
		Self.ScatterTargetTile=New Vec2i(0,35)
		Self.SetPosition(Self.HomeTile,0,4)
		Self.Dir=Direction.Up
		Self.NextDir=Self.Dir
		Self.Mode=GhostMode.Pen
		Self.SetSpeed()
		Self.DotCounter=0
		Self.ReleaseOnDot=350
	End
		
	Method GetTargetTile:Vec2i() Override
		'Find
		Local targetTile:Vec2i=Super.GetTargetTile()
		Select Self.Mode
			Case GhostMode.Chase
				'If within 8 tiles of pacman target him otherwise use scatter position
				Local distanceToPacman:Int=Sqrt(Self.GetDistanceToTarget(Self.Tile,Pacman.Tile))
				If (distanceToPacman>8) targetTile=ScatterTargetTile				 				
			case GhostMode.Scatter
				targetTile=ScatterTargetTile				
		End
		Return targetTile	
	End

End

Class PacmanSprite Extends Sprite
	Field Score:Int=0
	
	Method New(image:string)
		Super.New(image)
		Self.Reset()
	End

	Method Reset() Override
		Self.HomeTile=New Vec2i(14,26)
		Self.SetPosition(Self.HomeTile,0,4)
		Self.Dir=Direction.Left
		Self.SetSpeed()
		Self.Score=0
	End
			
	Method Update() Override
		'Prepare
		Local isCentreTile:Bool = Self.IsCentreTile(Self.X,Self.Y)
		Local currentTile:Vec2i=Self.Tile
		
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
				
		'Eat pill?
		If (Grid[2,currentTile.X,currentTile.Y]=1)
			'Collect pill
			Grid[2,currentTile.X,currentTile.Y]=0
			Self.Score+=10
			
			'Pause for this frame when eating pills
			Return
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