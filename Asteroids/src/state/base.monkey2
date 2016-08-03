
Class BaseState Extends State

Private
	Field _flashCounterTimer:CounterTimer
Public
	Field FlashState:Bool=False

	Method New()
		'Initialise
		_flashCounterTimer=New CounterTimer(30)		
	End Method
	
	Method Update:Void() Override
		'Base
		Super.Update()

		'Update
		UpdateCounterTimers()
		
		'Validate
		If (_flashCounterTimer.Elapsed)
			_flashCounterTimer.Reset()
			Self.FlashState=Not Self.FlashState
		End
		
	End
	
	Method PostRender:Void(canvas:Canvas,tween:Double) Override
		'Message
		VectorFont.DrawFont(canvas,"ASTEROIDS BY CHUNKYPIXEL STUDIOS",GAME.Height-20,1.0)		
	End
	
End Class
