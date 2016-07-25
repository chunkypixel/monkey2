
Class TitleState Extends State

Private
	Field _scale:InterPolated
Public

	Method New()	
		_scale=New InterPolated(6.0,7.5,40)
	End

	Method Enter:Void() Override
		'Create/reset stuff
	End

	Method Leave:Void() Override
		'Tidup/save stuff
	End
	
	Method Update:Void() Override
		'Process
		_scale.Update()
		
		'Start game?
		If (KeyboardControlHit("FIRE") Or JoystickButtonHit("FIRE")) GAME.EnterState( ASTEROIDS_STATE, New TransitionFadein, New TransitionFadeout )
	End

	Method Render:Void(canvas:Canvas, tween:Double) Override

		canvas.DrawImage(LogoImage,320,100,DegreesToRadians(10),_scale.Value,_scale.Value)

		canvas.Color = Color.White
		Game.DrawText(canvas, "HIGH SCORE",0,1)
		Game.DrawText(canvas, "000000",0,15)
		Game.DrawText(canvas, "GRID WARS", 0, Game.Height/2)

		canvas.Color = Color.Red
		Game.DrawText(canvas, "Press FIRE to Play!",0,Game.Height-30)

		canvas.Color = Color.Green
		Game.DrawText(canvas, "[ESCAPE] for main menu",0,Game.Height-15)
		
	End
	
End Class
