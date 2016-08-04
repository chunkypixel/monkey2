
Enum TitleStatus
	Intro
	HighScores
	Points
End

Class TitleState Extends BaseState

Private
	Field _status:Int=TitleStatus.Intro
	Field _stateCounterTimer:CounterTimer
Public

	Method New()
		_stateCounterTimer=New CounterTimer(800)	
	End

	Method Enter:Void() Override
		'Create/reset stuff
		_status=TitleStatus.Intro
		_stateCounterTimer.Reset()
	End

	Method Leave:Void() Override
		'Tidup/save stuff
	End
	
	Method Update:Void() Override
		'Base
		Super.Update()
			
		'Cycle states
		If (_stateCounterTimer.Elapsed) 
			_status=(_status+1) Mod 2
			_stateCounterTimer.Reset()
		End
		
		'Start game?
		If (KeyboardControlHit("FIRE") Or JoystickButtonHit("FIRE")) GAME.EnterState(GAME_STATE,New TransitionFadein,New TransitionFadeout)		
	End

	Method Render:Void(canvas:Canvas, tween:Double) Override
		'Logo
		canvas.DrawImage(GetImage("Logo"),GAME.Width/2,0)
		
		'Messages
		Select _status
			Case TitleStatus.Intro
				VectorFont.DrawFont(canvas,"ASTEROIDS",180,2.2)	
				VectorFont.DrawFont(canvas,"CHUNKYPIXEL STUDIOS 2017",200,1.2)	
				
				VectorFont.DrawFont(canvas,"BUILT WITH MONKEY2 AND THE GAME2D FRAMEWORK",270,1.8)	
				VectorFont.DrawFont(canvas,"THANKS TO MARK SIBLY AND WIEBO DE WIT",290,1.2)	
				VectorFont.DrawFont(canvas,"PARTICLE ENGINE AND VECTOR FONT BY MARK INCITTI",310,1.1)	

			Case TitleStatus.Points
				VectorFont.DrawFont(canvas,"SCORING",180,2.2)	
				VectorFont.DrawFont(canvas,"SHOOT ASTEROIDS AND AVOID UFOS",200,1.2)	
				
				If (_stateCounterTimer.Counter>50)  VectorFont.DrawFont(canvas,"     20 POINTS",240,2.0)	
				If (_stateCounterTimer.Counter>100) VectorFont.DrawFont(canvas,"     50 POINTS",280,2.0)	
				If (_stateCounterTimer.Counter>150) VectorFont.DrawFont(canvas,"    100 POINTS",320,2.0)	
				If (_stateCounterTimer.Counter>200) VectorFont.DrawFont(canvas,"    200 POINTS",360,2.0)	
				If (_stateCounterTimer.Counter>250) VectorFont.DrawFont(canvas,"   1000 POINTS",400,2.0)	

			Case TitleStatus.HighScores
				VectorFont.DrawFont(canvas,"HIGH SCORES",180,2.2)	
				
				If (_stateCounterTimer.Counter>50)  VectorFont.DrawFont(canvas,"1,  10000 MKS",240,2.0)	
				If (_stateCounterTimer.Counter>100) VectorFont.DrawFont(canvas,"2,   9000 MAK",260,2.0)	
				If (_stateCounterTimer.Counter>150) VectorFont.DrawFont(canvas,"3,   8000 WIE",280,2.0)	
				If (_stateCounterTimer.Counter>200) VectorFont.DrawFont(canvas,"4,   7000 ATA",300,2.0)	
				If (_stateCounterTimer.Counter>250) VectorFont.DrawFont(canvas,"5,   6000 COU",320,2.0)	
				'Print "Length:"+VectorFont.Length(13,1.8)
		End
				
		'Play
		If (Self.FlashState) VectorFont.DrawFont(canvas,"PRESS FIRE TO PLAY",Game.Height-60,2.0)	
	End
	
End Class
