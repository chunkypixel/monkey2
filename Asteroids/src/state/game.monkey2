Const LAYER_CAMERA:Int=0
Const LAYER_ROCKS:Int=1
Const LAYER_BULLETS:Int=2
Const LAYER_PLAYER:Int=3
Const LAYER_PARTICLES:Int=4

Class GameState Extends State

Private
	Field _particles:ParticleManager
	Field _camera:CameraEntity
	Field _maxRocks:Int=2
Public
	Field Player:PlayerEntity
	Field RockCount:Int

	Method Enter:Void() Override
		'Create/reset stuff
		CreatePlayer()
		CreateRocks()
		
		'Particles
		_particles=New ParticleManager()
		_particles.Alpha=1.0	
		
		'Camera
		Local anchor:Entity=New Entity()
		anchor.ResetPosition(GAME.Width/2,GAME.Height/2)
		AddEntity(anchor,LAYER_CAMERA)
		_camera=New CameraEntity()
		AddEntity(_camera,LAYER_CAMERA)
		_camera.Target=anchor
		_camera.SnapToTarget()
	End Method

	Method Leave:Void() Override
		'Tidup/save stuff
		_particles=Null
		Self.Player=Null
		RemoveAllEntities()
	End Method

	Method Update:Void() Override
		'Level complete?
		if (Self.RockCount=0) Self.LevelUp()
		
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

		'Prepare
		Local score:String="00"
		If (Player.Score>0) score=Player.Score
		score="       "+score
		
		'Render
		canvas.Color=Color.White
		VectorFont.DrawFont(canvas,"SCORE",48,16,1.5)
		VectorFont.DrawFont(canvas,score.Right(7),40,28,1.5)

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
		Self.RockCount+=1	
	End Method
	Method RemoveRock:Void(rock:RockEntity)
		RemoveEntity(rock)
		Self.RockCount-=1
	End Method
	
Private
	Method CreatePlayer:Void()
		Player=New PlayerEntity()
		Player.State=Self
		Player.Reset()		
		AddEntity(Player,LAYER_PLAYER)
	End Method

	Method CreateRocks:Void()
		For Local count:=1 To _maxRocks
			Local position:=New Vec2f(Rnd(40,GAME.Width-40),Rnd(20,GAME.Height-20))	
			Self.CreateRock(position,ROCK_BIG,Rnd(360))
		Next
	End Method

	Method LevelUp:Void()
		'Increment
		_maxRocks+=1
		_maxRocks=Min(_maxRocks,11)
		
		'Restart
		Self.CreateRocks()
		'rockSplit+=1

		'local channel:= PlaySound("levelup")
		'channel.Volume = 1.0
	End Method
	
End Class
