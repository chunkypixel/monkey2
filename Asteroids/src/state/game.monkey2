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
		Rocks.MaxRocks=4

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
				
		'Player
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
		UFO=Null
		Player=Null
		Camera=Null
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
					_status=GameStatus.Play				
					Player.Enabled=True
					UFO.Enabled=True
				End	
						
			Case GameStatus.Play
				'Game over?
				If (Not Player.Enabled) 
					_status=GameStatus.GameOver
					_counter.Restart()	
					UFO.Enabled=False
					Return			
				End		
				
			Case GameStatus.GameOver
				'Exit game?
				If (_counter.Elapsed) 
					'Validate
					If (Self.IsHighScore())
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
		Select _status
			Case GameStatus.GetReady
				VectorFont.Write(canvas,"GET READY",150,2.8)		
			Case GameStatus.GameOver
				VectorFont.Write(canvas,"GAME OVER",150,2.8)
		End
		
		'Reset
		canvas.BlendMode=BlendMode.Alpha
	End Method
	
	Method PostRender:Void(canvas:Canvas,tween:Double) Override
		'Stop shake affecting this layer
		canvas.ClearMatrix()
		canvas.Color=Color.White

		'Base
		Super.PostRender(canvas,tween)
		
		'Score
		Local score:String="0"
		If (Player.Score>0) score=Player.Score
		score="        "+score
		VectorFont.Write(canvas,score.Right(8),154-100,4,2.5)
		'Length 12.5 - 2.5
		
		'High
		Local highScore:String="10000"
		If (_highScore>0) highScore=_highScore
		highScore="        "+highScore
		VectorFont.Write(canvas,highScore.Right(8),332-60,10,1.5)
		VectorFont.Write(canvas,"MKS",340,10,1.5)
		'Length 7.5 - 1.5

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
		
		'Level
		Local level:String="0"+Player.Level
		VectorFont.Write(canvas,level.Right(2),170,10,1.5)
		'Remaining
		Local remaining:String="0"+Rocks.Remaining()
		VectorFont.Write(canvas,remaining.Right(2),190,10,1.5)
				
		'Note
		VectorFont.Write(canvas,TITLE+" BY CHUNKYPIXEL STUDIOS",VirtualResolution.Height-20,1.0)		
	End Method

	Method IsHighScore:Bool()
		Return True
	End Method
			
End Class
