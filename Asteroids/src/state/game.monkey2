Const LAYER_CAMERA:Int=0
Const LAYER_ROCKS:Int=1
Const LAYER_BULLETS:Int=2
Const LAYER_PLAYER:Int=3
Const LAYER_PARTICLES:Int=4

Enum GameStateFlags
	GetReady=0
	Play=1
	GameOver=2
End

Class GameState Extends State

Private
	Field _particles:ParticleManager
	Field _camera:CameraEntity
	Field _maxRocks:Int
	Field _highScore:Int=0
	Field _stateCounterTimer:CounterTimer
	Field _shipLives:ShipEntity
Public
	Field Player:PlayerEntity
	Field GameState:GameStateFlags
		
	Method Enter:Void() Override
		'Create/reset stuff
		_maxRocks=4
			
		'Initialise
		InitialisePlayer()
		CreateRocks()
		_particles=New ParticleManager()
		_shipLives=New ShipEntity()
		
		'Camera (for shaking)
		Local anchor:Entity=New Entity()
		anchor.ResetPosition(GAME.Width/2,GAME.Height/2)
		AddEntity(anchor,LAYER_CAMERA)
		_camera=New CameraEntity()
		AddEntity(_camera,LAYER_CAMERA)
		_camera.Target=anchor
		_camera.SnapToTarget()
		
		'State
		Self.GameState=GameStateFlags.GetReady
		
		'Counter
		_stateCounterTimer=New CounterTimer(150)	
	End Method

	Method Leave:Void() Override
		'Tidup/save stuff
		_particles=Null
		_shipLives=Null
		Self.Player=Null
		RemoveAllEntities()
	End Method

	Method Update:Void() Override		
		'Update
		_particles.Update()
		UpdateCounterTimers()
		
		'Validate
		Select Self.GameState
			Case GameStateFlags.GetReady
				'Start game?
				If (_stateCounterTimer.Elapsed)	
					Self.GameState=GameStateFlags.Play				
					Self.Player.Enabled=True
				End
				
			Case GameStateFlags.Play
				'Level complete?
				If (Self.TotalRocks=0) Self.LevelUp()
				
				'Game over?
				If (Not Self.Player.Enabled) 
					Self.GameState=GameStateFlags.GameOver
					_stateCounterTimer.Reset()				
				End
				
			Case GameStateFlags.GameOver
				'Exit game?
				If (_stateCounterTimer.Elapsed) 
					GAME.EnterState(TITLE_STATE,New TransitionFadein,New TransitionFadeout)				
				End
		End

	End
	
	'Method PreRender:Void(canvas:Canvas,tween:Double) Override
	'End Method
	
	Method Render:Void(canvas:Canvas,tween:Double) Override
		'Prepare
		canvas.TextureFilteringEnabled=True
		canvas.BlendMode=BlendMode.Additive

		'Background
		Local background:=GetImage("Background")
		If (background<>Null) canvas.DrawImage(background,GAME.Width/2,GAME.Height/2)	
		'Entities
		Super.Render(canvas,tween)
		_particles.Render(canvas)

		'Messages
		Select Self.GameState
			Case GameStateFlags.GetReady
				VectorFont.DrawFont(canvas,"GET READY",GAME.Width/2-(126/2),150,2.8)
				
			Case GameStateFlags.Play
				'Debug (exclusion zone)
				'canvas.Color=Color.FromARGB($44444422)
				'canvas.DrawRect(GAME.Width/2-100,GAME.Height/2-100,200,200)
				
			Case GameStateFlags.GameOver
				VectorFont.DrawFont(canvas,"GAME OVER",GAME.Width/2-(126/2),150,2.8)
		End
		
		'Reset
		canvas.BlendMode=BlendMode.Alpha
	End Method
	
	Method PostRender:Void(canvas:Canvas,tween:Double) Override
		'Stop shake affecting this layer
		canvas.ClearMatrix()
		canvas.Color=Color.White

		'Score 1
		Local score:String="0"
		If (Player.Score>0) score=Player.Score
		score="        "+score
		VectorFont.DrawFont(canvas,score.Right(8),154-100,4,2.5)
		'Length 12.5 - 2.5
		
		'High
		Local highScore:String="0"
		If (Player.Score>_highScore) _highScore=Player.Score
		If (_highScore>0) highScore=_highScore
		highScore="        "+highScore
		VectorFont.DrawFont(canvas,highScore.Right(8),332-60,10,1.5)
		VectorFont.DrawFont(canvas,"MKS",340,10,1.5)
		'Length 7.5 - 1.5
		'Print "Length:"+VectorFont.Length(7,1.5)

		'Lives?
		Local lives:Int=Clamp(Self.Player.Lives,0,7)
		If (lives>0)
			'Prepare
			Local x:Int=154-(MAX_LIVES-1)*15

			'Process
			For Local count:Int=1 To lives
				_shipLives.Position=New Vec2f(x,35)
				_shipLives.Render(canvas)
				x+=15
			Next
		End
		
		'Message
		'VectorFont.DrawFont(canvas,"YOUR SCORE IS ONE OF THE TEN BEST",34,120,2.8)
		'VectorFont.DrawFont(canvas,"PLEASE ENTER YOUR INITIALS",34,140,2.8)
		'VectorFont.DrawFont(canvas,"PUSH ROTATE TO SELECT LETTER",34,160,2.8)
		'VectorFont.DrawFont(canvas,"PUSH HYPERSPACE WHEN LETTER IS CORRECT",34,180,2.8)
		
	End Method
			
	Method Shake:Void(radius:Float=2)
		_camera.Shake(radius)
	End Method

	Method InExclusionZone:Bool(entity:Entity)
		Return Self.InExclusionZone(entity.Position) 		
	End
	Method InExclusionZone:Bool(position:Vec2f)
		return (position.X>GAME.Width/2-120 And position.X<GAME.Width/2+120 And position.Y>GAME.Height/2-100 And position.Y<GAME.Height/2+100) 		
	End	
			
'Features (Particles)
	Method CreateTrail:Void(position:Vec2f,direction:Float)
		_particles.CreateTrail(position.X,position.Y,direction)
	End Method
	Method CreateExplosion:Void(position:Vec2f)
		_particles.CreateExplosion(position.X,position.Y)
	End Method

'Rocks
	Method CreateRock:Void(position:Vec2f,size:Int,direction:Int,speed:Float,enabled:Bool=True)
		Local rock:=New RockEntity(position,size,direction,speed)
		rock.Enabled=enabled
		AddEntity(rock,LAYER_ROCKS,"rocks")
	End Method
	
	Method SplitRock:Void(rock:RockEntity)
		'NOTES: Rocks continue to same general direction
		'       One rock appears to be move faster than other
		'       There can only ever be a max of 26 rocks
				
		'Can split?
		If (rock.Size<RockSize.Small)
			For Local count:Int=1 To 2
				'Validate
				If (Self.TotalRocks>26) Continue 

				'Direction (seperate) 
				Local direction:Int=rock.Direction
				If (count=1) direction-=Rnd(5,25)
				If (count=2) direction+=Rnd(10,40)
				
				'Speed
				Local speed:Float=rock.Speed+0.75
				If (count=1) speed-=0.25	'Reduce some
				
				'Create
				Self.CreateRock(rock.Position,rock.Size+1,direction,speed)
			Next
		End	
		
		'Remove parent rock
		Self.RemoveRock(rock)
	End Method
	
	Method RemoveRock:Void(rock:RockEntity)
		RemoveEntity(rock)
	End Method
	
	Property TotalRocks:Int()
		Local group:=GetEntityGroup("rocks")
		If (group=Null) Return 0 
		Return group.Entities.Count()
	End

'Bullets
	Property TotalBullets:Int()
		Local group:=GetEntityGroup("bullets")
		If (group=Null) Return 0 
		Return group.Entities.Count()
	End
	
Private
	Method InitialisePlayer:Void()
		Player=New PlayerEntity()
		Player.State=Self
		AddEntity(Player,LAYER_PLAYER)
	End Method

	Method CreateRocks:Void(enabled:Bool=False)
		'Prepare
		Local counter:Int=0
		
		'Process
		Repeat 
			'Get position and validate
			Local position:=New Vec2f(Rnd(40,GAME.Width-40),Rnd(20,GAME.Height-20))	
			If (Self.InExclusionZone(position)) Continue
						
			'Speed (increase base speed each level)
			Local speed:Float=1.0+Min(Self.Player.Level*0.1,1.0)
			If (Int(Rnd(0,2)>=1)) speed-=0.25	'Reduce some
			
			'Create
			Self.CreateRock(position,RockSize.Big,Rnd(360),speed,enabled)
			
			'Increment
			counter+=1
		Until (counter=_maxRocks)
	End Method

	Method LevelUp:Void()
		'Rocks start at 4 and increment 2 each level until a max of 11

		'Increment
		Self.Player.Level+=1
		_maxRocks+=2
		_maxRocks=Min(_maxRocks,11)
		
		'Restart
		Self.CreateRocks(True)

		'Sound
		local channel:=PlaySound("LevelUp")
		channel.Volume=1.0
	End Method
	
End Class
