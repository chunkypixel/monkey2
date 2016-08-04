
Class BaseState Extends State

Private
	Field _flashCounterTimer:CounterTimer
	Field _starfield:StarfieldManager
Public
	Field FlashState:Bool=False

	Method New()
		'Initialise
		_flashCounterTimer=New CounterTimer(30)		
		_starfield=New StarfieldManager()
	End Method
	
	Method Update:Void() Override
		'Base
		Super.Update()

		'Update
		UpdateCounterTimers()
		_starfield.Update()
		
		'Validate
		If (_flashCounterTimer.Elapsed)
			_flashCounterTimer.Reset()
			Self.FlashState=Not Self.FlashState
		End
	End
	
	Method Render:Void(canvas:Canvas,tween:Double) Override
		'Prepare
		canvas.TextureFilteringEnabled=True
		canvas.BlendMode=BlendMode.Additive

		'Background?
		'If (BACKGROUND_IMAGE)
		'	Local background:=GetImage("Background")
		'	If (background<>Null) canvas.DrawImage(background,GAME.Width/2,GAME.Height/2)	
		'End
				
		'Stars
		_starfield.Render(canvas)
	End Method
	
	'Method PostRender:Void(canvas:Canvas,tween:Double) Override
	'	'Message
	'	VectorFont.DrawFont(canvas,"ASTEROIDS BY CHUNKYPIXEL STUDIOS",GAME.Height-20,1.0)		
	'End
	
	Property Starfield:StarfieldManager()
		Return _starfield
	End
End Class
