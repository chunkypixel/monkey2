
Class PlayState Extends State

Private
	Field _grid:Grid
	Field _particles:ParticleManager
	Field _cnt:Int=0
	Field particleStyle:Int=3
public

	Method New()
		'Initialise 
		_grid=New Grid(GAME.Width,GAME.Height)
		_particles=New ParticleManager()
	End

	Method Enter:Void() Override
		'Create/reset stuff
	End Method

	Method Leave:Void() Override
		'Tidup/save stuff
	End Method
	
	Method Update:Void() Override
		'Exit?
		If (Keyboard.KeyHit(Key.F1)) GAME.EnterState( TITLE_STATE, New TransitionFadein, New TransitionFadeout )
		
		'Keys
		If (Keyboard.KeyHit(Key.G)) _grid.Style=(_grid.Style + 1) Mod 11
		If (Keyboard.KeyHit(Key.P)) particleStyle=(particleStyle + 1) Mod 5
		
		'Update
		_grid.Update()
		_particles.Update()
		
		'Test
		'If (Mouse.ButtonDown(MouseButton.Left))	_grid.Shockwave(Mouse.X,Mouse.Y)
		'If (Mouse.ButtonDown(MouseButton.Right)) 
		'	_particles.CreateParticles(Mouse.X,Mouse.Y,3,2,16)
			'_particles.CreateFireWorks(Rnd(0,3),Rnd(0,4))
		'	_grid.Shockwave(Mouse.X,Mouse.Y)
		'End
		
		'Increment
		_cnt+=1
		
		'Pull grid?
		If ((_cnt Mod 60)=0) _grid.Shockwave(Rnd(0,GAME.Width),Rnd(0,GAME.Height))
		'If ((_cnt Mod 60)=0) _grid.Pull(Rnd(0,GAME.Width),Rnd(0,GAME.Height),8,24)
		
		'Release particles?
		If(Rnd(0,100)>94) _particles.CreateFireWorks(0,particleStyle)
		
	End

	'Method PreRender:Void(canvas:Canvas, tween:Double) Override
	'End

	Method Render:Void(canvas:Canvas, tween:Double) Override
		'Settings
		canvas.TextureFilteringEnabled=True

		'Render
		_grid.Render(canvas)
		_particles.Render(canvas)
		
		'Debug
		canvas.Color = Color.White
		'Game.DrawText(canvas, "PLAYSTATE",0,0)
		canvas.DrawText("GS:"+_grid.Style,8,15)
		canvas.DrawText("PS:"+particleStyle,8,30)
		
	End
	
	'Method PostRender:Void(canvas:Canvas, tween:Double) Override
	'End
End Class
