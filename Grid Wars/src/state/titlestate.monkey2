
Class TitleState Extends State

Private
	Field _logo:Image
	Field _scale:InterPolated
Public

	Method New()	
		_logo=Image.Load("asset::logo.png")
		DebugAssert(_logo<>Null,"logo not loaded!!")
		_logo.Handle=New Vec2f(0.5,0.5)
		_scale=New InterPolated(4.0,5.0,720)
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
		If (Keyboard.KeyHit(Key.Enter)) GAME.EnterState( PLAY_STATE, New TransitionFadein, New TransitionFadeout )

	End


	Method Render:Void(canvas:Canvas, tween:Double) Override

		canvas.DrawImage(_logo,160,60,DegreesToRadians(10),_scale.Value,_scale.Value)

		canvas.Color = Color.White
		Game.DrawText(canvas, "HIGH SCORE",0,1)
		Game.DrawText(canvas, "000000",0,15)
		Game.DrawText(canvas, "GRID WARS", 0, Game.Height/2)

		canvas.Color = Color.Red
		Game.DrawText(canvas, "Press ENTER to Play!",0,Game.Height-30)

		canvas.Color = Color.Green
		Game.DrawText(canvas, "[ESCAPE] for main menu",0,Game.Height-15)
		
	End
	
End Class
