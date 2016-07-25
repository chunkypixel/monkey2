Const LAYER_CAMERA:Int=0

Class GameState Extends State

Private
	Field _grid:GridManager
	Field _particles:ParticleManager
	Field _camera:CameraEntity
public

	Method Enter:Void() Override
		'Create/reset stuff
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
	End Method

	Method Update:Void() Override
		'Update
		_grid.Update()
		_particles.Update()
		
		'Change grid style
		If (Keyboard.KeyHit(Key.G)) _grid.Style=(_grid.Style+1) Mod _grid.TotalStyles
		
	End
	
	'Method PreRender:Void(canvas:Canvas,tween:Double) Override
	'	_grid.Render(canvas)
	'End Method
	
	Method Render:Void(canvas:Canvas,tween:Double) Override
		_grid.Render(canvas)
		Super.Render(canvas,tween)
		_particles.Render(canvas)
	End Method
	
	'Method PostRender:Void(canvas:Canvas,tween:Double) Override
	'	_particles.Render(canvas)
	'End Method
	
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
			
End Class
