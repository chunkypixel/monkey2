
Class TitleState Extends State

Private
	Field _flashCounterTimer:CounterTimer
	Field _showPlayMessage:Bool=True
Public

	Method New()
		'Initialise
		_flashCounterTimer=New CounterTimer(25)	
	End

	Method Enter:Void() Override
		'Create/reset stuff
	End

	Method Leave:Void() Override
		'Tidup/save stuff
	End
	
	Method Update:Void() Override
		'Update
		UpdateCounterTimers()
		
		'Validate
		If (_flashCounterTimer.Elapsed)
			_flashCounterTimer.Reset()
			_showPlayMessage=Not _showPlayMessage
		End
		
		'Start game?
		If (KeyboardControlHit("FIRE") Or JoystickButtonHit("FIRE")) GAME.EnterState(GAME_STATE,New TransitionFadein,New TransitionFadeout)		
	End

	Method Render:Void(canvas:Canvas, tween:Double) Override
		'Logo
		canvas.DrawImage(GetImage("Logo"),GAME.Width/2,0)

		'Message
		If (_showPlayMessage) VectorFont.DrawFont(canvas,"PRESS FIRE TO PLAY",Game.Height-40,1.8)
		
	End
	
End Class
