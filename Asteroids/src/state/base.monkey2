
Class StateBase Extends State

Private
	Field _flashCounter:CounterTimer
Public
	Field FlashState:Bool=False

	Method New()
		'Initialise
		_flashCounter=New CounterTimer(30)		
	End Method
	
	Method Update:Void() Override
		'Base
		Super.Update()

		'Update
		Timers.Update()
		Particles.Update()
		Starfield.Update()
		
		'Validate
		If (_flashCounter.Elapsed)
			_flashCounter.Restart()
			Self.FlashState=Not Self.FlashState
		End
	End
	
	Method Render:Void(canvas:Canvas,tween:Double) Override
		'Prepare
		canvas.TextureFilteringEnabled=True
		canvas.BlendMode=BlendMode.Additive
		canvas.Color=Color.White
		canvas.Alpha=1.0
			
		'Render
		Starfield.Render(canvas)
	End Method
	
	Method PostRender:Void(canvas:Canvas,tween:Double) Override
		'Prepare
		canvas.TextureFilteringEnabled=True
		canvas.BlendMode=BlendMode.Additive
		canvas.Color=Color.White
		canvas.Alpha=1.0

		'Render
		Particles.Render(canvas)
	End Method
		
End Class
