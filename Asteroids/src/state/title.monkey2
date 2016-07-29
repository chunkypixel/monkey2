
Class TitleState Extends State

Private
	Field _scale:InterPolated
Public

	Method New()	
		_scale=New InterPolated(1,1,40)
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
		If (KeyboardControlHit("FIRE") Or JoystickButtonHit("FIRE")) GAME.EnterState( GAME_STATE, New TransitionFadein, New TransitionFadeout )
	End

	Method Render:Void(canvas:Canvas, tween:Double) Override
		'Logo
		canvas.DrawImage(GetImage("Logo"),GAME.Width/2,0)


		'canvas.Color = Color.White
		'Game.DrawText(canvas, "HIGH SCORE",0,1)
		'Game.DrawText(canvas, "000000",0,15)
		'Game.DrawText(canvas, "GRID WARS", 0, Game.Height/2)

		'canvas.Color = Color.Red
		VectorFont.DrawFont(canvas,"PRESS FIRE TO PLAY",Game.Width/2-(225/2),Game.Height-60,2.5)
		Print "Length:"+VectorFont.Length(18,2.5)
		
		'Game.DrawText(canvas, "Press FIRE to Play!",0,Game.Height-30)

		'canvas.Color = Color.Green
		'Game.DrawText(canvas, "[ESCAPE] for main menu",0,Game.Height-15)
		
	End
	
End Class
