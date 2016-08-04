
Enum TitleStatus
	Title
	HighScores
	About
	Points
End

Class TitleState Extends BaseState

Private
	Field _status:Int
	Field _counterTimer:CounterTimer
Public

	Method New()
		'Initialise
		_counterTimer=New CounterTimer(600)	
	End

	Method Enter:Void() Override
		'Create/reset stuff
		_status=TitleStatus.Title
		_counterTimer.Reset()
		
		'Starfield
		Self.Starfield.Speed=0.5
		Self.Starfield.Rotation=0.05
	End

	Method Leave:Void() Override
		'Tidup/save stuff
	End
	
	Method Update:Void() Override
		'Base
		Super.Update()
			
		'Cycle status
		If (_counterTimer.Elapsed) 
			_status=(_status+1) Mod 3
			_counterTimer.Reset()
		End
		
		'Start game?
		If (KeyboardControlHit("FIRE") Or JoystickButtonHit("FIRE")) GAME.EnterState(GAME_STATE,New TransitionFadein,New TransitionFadeout)		
	End

	Method Render:Void(canvas:Canvas,tween:Double) Override
		'Base
		Super.Render(canvas,tween)
		
		'Messages
		Select _status
			Case TitleStatus.Title
				VectorFont.DrawFont(canvas,TITLE,40,270,7.5)	
				
				VectorFont.DrawFont(canvas,"BY CHUNKYPIXEL STUDIOS",40,320,1.5)	
				VectorFont.DrawFont(canvas,"0.2 05.08.16",40,335,0.8)	
				
			Case TitleStatus.HighScores
				VectorFont.DrawFont(canvas,"HIGH SCORES",100,2.2)	
				
				If (_counterTimer.Counter>50)  VectorFont.DrawFont(canvas,"1.  10000 MKS",160,2.0)	
				If (_counterTimer.Counter>100) VectorFont.DrawFont(canvas,"2.   9000 MAK",180,2.0)	
				If (_counterTimer.Counter>150) VectorFont.DrawFont(canvas,"3.   8000 WIE",200,2.0)	
				If (_counterTimer.Counter>200) VectorFont.DrawFont(canvas,"4.   7000 ATA",220,2.0)	
				If (_counterTimer.Counter>250) VectorFont.DrawFont(canvas,"5.   6000 COU",240,2.0)	
				
			Case TitleStatus.About
				VectorFont.DrawFont(canvas,TITLE,40,290,3.0)	
				
				VectorFont.DrawFont(canvas,"BUILT WITH MONKEY2 AND THE GAME2D FRAMEWORK",40,320,1.5)	
				VectorFont.DrawFont(canvas,"THANKS TO MARK SIBLY AND WIEBO DE WIT",40,337,1.2)	
				VectorFont.DrawFont(canvas,"PARTICLE ENGINE AND VECTOR FONT BY MARK INCITTI",40,350,1.2)	
			
			Case TitleStatus.Points
				VectorFont.DrawFont(canvas,"SCORING",100,2.2)	
				VectorFont.DrawFont(canvas,"SHOOT ASTEROIDS AND AVOID UFOS",120,1.2)	
				
				If (_counterTimer.Counter>50)  VectorFont.DrawFont(canvas,"     20 POINTS",160,2.0)	
				If (_counterTimer.Counter>100) VectorFont.DrawFont(canvas,"     50 POINTS",190,2.0)	
				If (_counterTimer.Counter>150) VectorFont.DrawFont(canvas,"    100 POINTS",220,2.0)	
				If (_counterTimer.Counter>200) VectorFont.DrawFont(canvas,"    200 POINTS",250,2.0)	
				If (_counterTimer.Counter>250) VectorFont.DrawFont(canvas,"   1000 POINTS",280,2.0)	
		End
				
		'Display?
		If (Self.FlashState) VectorFont.DrawFont(canvas,"PRESS FIRE TO PLAY",Game.Height-60,2.0)	
		
		'Reset
		canvas.BlendMode=BlendMode.Alpha
	End
	
End Class
