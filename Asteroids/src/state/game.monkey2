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
		
	End Method

	Method Leave:Void() Override
		'Tidup/save stuff
		_particles=Null
		Self.Player=Null
		RemoveAllEntities()
	End Method

	Method Update:Void() Override
		'Level complete?
		if (Self.TotalRocks=0) Self.LevelUp()
		
		'Update
		_particles.Update()
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
		
		'Reset
		canvas.BlendMode=BlendMode.Alpha
	End Method
	
	Method PostRender:Void(canvas:Canvas,tween:Double) Override
		'Stop shake affecting this layer
		canvas.ClearMatrix()
		canvas.Color=Color.White

		'Score 1
		Local score:String="00"
		If (Player.Score>0) score=Player.Score
		score="       "+score
		VectorFont.DrawFont(canvas,score.Right(7),40,4,2.8)
		
		'High
		Local highScore:String="00"
		If (Player.Score>_highScore) _highScore=Player.Score
		If (_highScore>0) highScore=_highScore
		highScore="       "+highScore
		VectorFont.DrawFont(canvas,highScore.Right(7),290,14,1.4)

		'Validate
		Select Self.GameState
			Case GameStateFlags.GetReady
				VectorFont.DrawFont(canvas,"GET READY",250,120,2.8)
				
				'TODO: Validate (timer)
				Self.GameState=GameStateFlags.Play
				
			Case GameStateFlags.GameOver
				VectorFont.DrawFont(canvas,"GAME OVER",250,120,2.8)
				
				'TODO: Validate (timer)
				Self.EndGame()
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
		
	Method EndGame:Void()
		Game.EnterState(TITLE_STATE,New TransitionFadein,New TransitionFadeout)
	End
	
'Features (Particles)
	Method CreateTrail:Void(position:Vec2f,direction:Float)
		_particles.CreateTrail(position.X,position.Y,direction)
	End Method
	Method CreateExplosion:Void(position:Vec2f)
		_particles.CreateExplosion(position.X,position.Y)
	End Method

'Rocks
	Method CreateRock:Void(position:Vec2f,size:Int,direction:Int)
		Local rock:=New RockEntity(position,size,direction)
		AddEntity(rock,LAYER_ROCKS,"rocks")
	End Method
	
	Method SplitRock:Void(rock:RockEntity)
		'Can split?
		If (rock.Size<RockSize.Small)
			For Local count:Int=1 To 2
				'Validate
				'There can only ever be a max of 26 rocks
				If (Self.TotalRocks>26) Continue 
				
				'Get direction
				'NOTES: Appears to have rock continue to same general direction
				'       One rock appears to be faster than the other
				Local direction:Int=rock.Direction
				If (count=1) direction-=20
				If (count=2) direction+=20
				
				'Create
				Self.CreateRock(rock.Position,rock.Size+1,direction)
			Next
		End	
		
		'Remove original rock
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

	Method CreateRocks:Void()
		'Process
		For Local count:=1 To _maxRocks
			Local position:=New Vec2f(Rnd(40,GAME.Width-40),Rnd(20,GAME.Height-20))	
			Self.CreateRock(position,RockSize.Big,Rnd(360))
		Next
	End Method

	Method LevelUp:Void()
		'Increment
		'Rocks start at 4 and increment 2 each level until a max of 11
		_maxRocks+=2
		_maxRocks=Min(_maxRocks,11)
		
		'Restart
		Self.CreateRocks()

		'local channel:= PlaySound("levelup")
		'channel.Volume = 1.0
	End Method
	
End Class
