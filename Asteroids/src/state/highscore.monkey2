
Class HighScoreState Extends StateBase
Private
Public

	Method Enter:Void() Override
		'Create/reset stuff
	End Method

	Method Leave:Void() Override
		'Tidup/save stuff
	End Method

	Method Update:Void() Override
		'Base
		Super.Update()
		
		'Exit	
		If (KeyboardControlHit("FIRE") Or JoystickButtonHit("FIRE")) GAME.EnterState(TITLE_STATE,New TransitionFadein,New TransitionFadeout)
	End
	
	Method Render:Void(canvas:Canvas,tween:Double) Override
		'Base
		Super.Render(canvas,tween)

		'Message
		VectorFont.Write(canvas,"YOUR SCORE IS ONE OF THE FIVE BEST",34,120,2.8)
		VectorFont.Write(canvas,"PLEASE ENTER YOUR INITIALS",34,140,2.8)
		VectorFont.Write(canvas,"PUSH ROTATE TO SELECT LETTER",34,160,2.8)
		VectorFont.Write(canvas,"PUSH FIRE WHEN LETTER IS CORRECT",34,180,2.8)
	
	End Method
	
End Class
