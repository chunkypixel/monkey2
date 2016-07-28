Const LAYER_CAMERA:Int=0
Const LAYER_ROCKS:Int=1
Const LAYER_BULLETS:Int=2
Const LAYER_PLAYER:Int=3
Const LAYER_PARTICLES:Int=4

Class GameState Extends State

Private
	Field _grid:GridManager
	Field _particles:ParticleManager
	Field _camera:CameraEntity
Public
	Field Player:PlayerEntity
	Field RockCount:Int

	Method Enter:Void() Override
		'Create/reset stuff
		CreatePlayer()
		CreateRocks()

		'Grid
		_grid=New GridManager(GAME.Width,GAME.Height,8)
		_grid.Alpha=0.25
		_particles=New ParticleManager()
		_particles.Alpha=1.0
		
		'Camera Layer
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
		_grid=Null
		_particles=Null
		Self.Player=Null
		RemoveAllEntities()
	End Method

	Method Update:Void() Override
		'Update
		'_grid.Update()
		_particles.Update()
		
		'Change grid style
		If (Keyboard.KeyHit(Key.G)) _grid.Style=(_grid.Style+1) Mod _grid.TotalStyles		
	End
	
	'Method PreRender:Void(canvas:Canvas,tween:Double) Override
	'	_grid.Render(canvas)
	'End Method
	
	Method Render:Void(canvas:Canvas,tween:Double) Override
		'_grid.Render(canvas)
		canvas.DrawImage(BackgroundImage,0,0)
		Super.Render(canvas,tween)
		_particles.Render(canvas)
	End Method
	
	Method PostRender:Void(canvas:Canvas,tween:Double) Override
		'Prepare
		Local score:String="00"
		If (Player.Score>0) score=Player.Score
		score="       "+score
		Local highScore:String="       00"
		
		'Render
		canvas.Color=Color.Red
		canvas.DrawText("SCORE",48,8)
		canvas.DrawText("HIGH-SCORE",GAME.Width/2-40,8)
		canvas.Color=Color.White
		canvas.DrawText(score.Right(7),40,18)
		canvas.DrawText(highScore.Right(7),GAME.Width/2-32,18)
	End Method
		
	Method Shake:Void(radius:Float=2)
		_camera.Shake(radius)
	End Method
	
'Features (Grid)
	
	Method Shockwave(x:Int,y:Int)
		_grid.Shockwave(x,y)
		Self.Shake()
	End Method
	Method BombShockwave(x:Int,y:Int)
		_grid.BombShockwave(x,y)
		Self.Shake(5)
	End Method
	
'Features (Particles)

	Method Fireworks(x:Int,y:Int,style:Int=3,type:Int=0)
		_particles.CreateParticles(x,y,style,type,64)
	End Method
	Method Trail(x:Int,y:Int,direction:Float)
		_particles.CreateTrail(x,y,direction)
	End Method
	Method Explosion(x:Int,y:Int)
		_particles.CreateExplosion(x,y)
	End Method

'Rocks
	Method CreateRock:Void(position:Vec2f,size:Int,direction:Int)
		Local rock:=New RockEntity(position,size,direction)
		AddEntity(rock,LAYER_ROCKS,"rocks")
		'AddEntityToGroup(rock, "rocks")
		Self.RockCount+=1	
	End
	Method RemoveRock:Void(rock:RockEntity)
		RemoveEntity(rock)
		Self.RockCount-=1
	End
	
Private
	Method CreatePlayer:Void()
		Player=New PlayerEntity()
		Player.State=Self
		Player.Reset()		
		AddEntity(Player,LAYER_PLAYER)
	End Method

	Method CreateRocks:Void()
		For Local count:=1 To 2
			Local position:=New Vec2f(Rnd(40,GAME.Width-40),Rnd(20,GAME.Height-20))
			Self.CreateRock(position,ROCK_BIG,Rnd(360))
		Next
	End Method
	
End Class
