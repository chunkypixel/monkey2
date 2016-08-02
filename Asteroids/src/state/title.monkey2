
Class TitleState Extends BaseState

	Method New()
	End

	Method Enter:Void() Override
		'Create/reset stuff
	End

	Method Leave:Void() Override
		'Tidup/save stuff
	End
	
	Method Update:Void() Override
		'Base
		Super.Update()
			
		'Start game?
		If (KeyboardControlHit("FIRE") Or JoystickButtonHit("FIRE")) GAME.EnterState(GAME_STATE,New TransitionFadein,New TransitionFadeout)		
	End

	Method Render:Void(canvas:Canvas, tween:Double) Override
		'Logo
		canvas.DrawImage(GetImage("Logo"),GAME.Width/2,0)

		'Message
		If (Self.FlashState) VectorFont.DrawFont(canvas,"PRESS FIRE TO PLAY",Game.Height-80,2.0)	
	End
	
End Class
