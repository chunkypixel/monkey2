Global Camera:CameraEntity

Enum GameStatus
	GetReady=0
	Play=1
	GameOver=2
End

Class GameState Extends StateBase
Private
	Field _highScore:Int=0
	Field _status:GameStatus
	Field _counter:CounterTimer
Public
		
	Method Enter:Void() Override
		'Create/reset stuff
		Rocks.MaxRocks=ROCKS_START

		'Starfield
		Starfield.Speed=0.05
		Starfield.Rotation=0.0

		'Camera (for shaking)
		Camera=New CameraEntity()
		Local anchor:Entity=New Entity()
		anchor.ResetPosition(GAME.Width/2,GAME.Height/2) 'NOTE: Must be actual screen not virtual
		AddEntity(anchor,LAYER_CAMERA)
		AddEntity(Camera,LAYER_CAMERA)
		Camera.Target=anchor
		Camera.SnapToTarget()
				
		'Player (re-init)
		Player=New PlayerEntity()
		AddEntity(Player,LAYER_PLAYER,"player")
		ShipLives=New ShipEntity()
			
		'Rocks
		Rocks.Create()
		
		'UFO
		UFO=New UFOEntity()
		AddEntity(UFO,LAYER_UFO,"ufo")
		
		'State
		_status=GameStatus.GetReady
		_counter=New CounterTimer(250)
	End Method

	Method Leave:Void() Override
		'Tidup/save stuff
		ShipLives=Null
		'UFO=Null
		'Player=Null
		'Camera=Null
		RemoveAllEntities()
	End Method

	Method Update:Void() Override	
		'Base
		Super.Update()
			
		'Update
		Thump.Update()
		
		'Validate
		Select _status
			Case GameStatus.GetReady
				'Start game?
				If (_counter.Elapsed)	
					'Set
					_status=GameStatus.Play		
					Player.Enabled=True
					UFO.Enabled=False
				End	
						
			Case GameStatus.Play
				'Game over?
				If (Not Player.Enabled) 
					'Set
					_status=GameStatus.GameOver
					_counter.Restart()	
					Return			
				End		
				
			Case GameStatus.GameOver
				'Exit game?
				If (_counter.Elapsed) 
					'Set
					UFO.Enabled=False
					
					'Validate
					If (HighScores.IsHighScore(Player.Score))
						GAME.EnterState(HIGHSCORE_STATE,New TransitionFadein,New TransitionFadeout)				
					Else
						GAME.EnterState(TITLE_STATE,New TransitionFadein,New TransitionFadeout)				
					End
				End
		End

	End
	
	'Method PreRender:Void(canvas:Canvas,tween:Double) Override
	'End Method
	
	Method Render:Void(canvas:Canvas,tween:Double) Override	
		'Entities and particles
		Super.Render(canvas,tween)

		'Messages
		canvas.Color=MessageColor
		Select _status
			Case GameStatus.GetReady
				VectorFont.Write(canvas,"GET READY",150,2.8)		
			'Case GameStatus.Play
			'	If (Player.Status=PlayerStatus.Release)	VectorFont.Write(canvas,"GET READY",150,2.8)		
			Case GameStatus.GameOver
				VectorFont.Write(canvas,"GAME OVER",150,2.8)
		End
		
		'Reset
		canvas.BlendMode=BlendMode.Alpha
	End Method
	
	Method PostRender:Void(canvas:Canvas,tween:Double) Override
		'Stop shake affecting this layer
		canvas.ClearMatrix()

		'Base
		Super.PostRender(canvas,tween)
		canvas.Color=HUDColor
		
		'Score
		Local score:String="0"
		If (Player.Score>0) score=Player.Score
		VectorFont.Write(canvas,("        "+score).Right(8),154-100,4,2.5)	'Length 12.5 - 2.5
	
		'High
		Local highScore:=Cast<Score>(HighScores.List.Get(0))
		If (highScore<>Null)
			VectorFont.Write(canvas,("        "+highScore.Score).Right(8),332-60,10,1.5)
			VectorFont.Write(canvas,highScore.Name,340,10,1.5) 'Length 7.5 - 1.5		
		End

		'Level
		Local level:String="0"+Player.Level
		VectorFont.Write(canvas,level.Right(2),170,10,1.5)
		'Remaining
		Local remaining:String="0"+Rocks.Remaining()
		VectorFont.Write(canvas,remaining.Right(2),190,10,1.5)

		'Note
		VectorFont.Write(canvas,TITLE+" BY CHUNKYPIXEL STUDIOS",VirtualResolution.Height-20,1.0)				

		'Lives?
		Local lives:Int=Clamp(Player.Lives,0,7)
		If (lives>0)
			'Prepare
			Local x:Int=154-(MAX_LIVES-1)*15

			'Process
			For Local count:Int=1 To lives
				ShipLives.Position=New Vec2f(x,35)
				ShipLives.Render(canvas)
				x+=15
			Next
		End
	End Method
			
End Class
