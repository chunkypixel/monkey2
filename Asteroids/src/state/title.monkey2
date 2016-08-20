
Enum TitleStatus
	Title
	HighScores
	About
	Points
End

Class TitleState Extends StateBase

Private
	Field _status:Int	'TitleStatus
	Field _counterTimer:CounterTimer
Public

	Method New()
		'Initialise
		_counterTimer=New CounterTimer(600)	
	End

	Method Enter:Void() Override
		'Create/reset stuff
		_status=TitleStatus.Title
		_counterTimer.Restart()
				
		'Starfield
		Starfield.Speed=0.5
		Starfield.Rotation=0.1
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
			_counterTimer.Restart()
		End
		
		'Start game?
		If (KeyboardControlHit("FIRE") Or JoystickButtonHit("FIRE")) GAME.EnterState(GAME_STATE,New TransitionFadein,New TransitionFadeout)	
		
		'Testing
		If (Keyboard.KeyHit(Key.A)) Particles.CreateExplosion(New Vec2f(200,VirtualResolution.Height/2),1)	
		If (Keyboard.KeyHit(Key.S)) Particles.CreateExplosion(New Vec2f(VirtualResolution.Width/2,VirtualResolution.Height/2),2)	
		If (Keyboard.KeyHit(Key.D)) Particles.CreateExplosion(New Vec2f(VirtualResolution.Width-200,VirtualResolution.Height/2),3)	
	End

	Method Render:Void(canvas:Canvas,tween:Double) Override
		'Base
		Super.Render(canvas,tween)
		
		'Messages
		Select _status
			Case TitleStatus.Title
				canvas.Color=TitleColor
				VectorFont.Write(canvas,TITLE,40,270,7.5)			
				
				canvas.Color=SubTitleColor
				VectorFont.Write(canvas,"BY CHUNKYPIXEL STUDIOS",40,320,1.5)	
				VectorFont.Write(canvas,VERSION,40,335,0.8)	
				
			Case TitleStatus.HighScores
				canvas.Color=TitleColor
				VectorFont.Write(canvas,"HIGH SCORES",100,2.2)	
				
				canvas.Color=SubTitleColor
				If (_counterTimer.Counter>50)  VectorFont.Write(canvas,GetScoreSummary(1),160,2.0)	
				If (_counterTimer.Counter>100) VectorFont.Write(canvas,GetScoreSummary(2),180,2.0)	
				If (_counterTimer.Counter>150) VectorFont.Write(canvas,GetScoreSummary(3),200,2.0)	
				If (_counterTimer.Counter>200) VectorFont.Write(canvas,GetScoreSummary(4),220,2.0)	
				If (_counterTimer.Counter>250) VectorFont.Write(canvas,GetScoreSummary(5),240,2.0)	
				
			Case TitleStatus.About
				canvas.Color=TitleColor
				VectorFont.Write(canvas,TITLE,40,295,3.0)	
				
				canvas.Color=SubTitleColor
				VectorFont.Write(canvas,"BUILT WITH MONKEY2 AND THE GAME2D FRAMEWORK",40,320,1.5)	
				VectorFont.Write(canvas,"THANKS TO MARK SIBLY AND WIEBO DE WIT",40,335,1.2)	
				VectorFont.Write(canvas,"PARTICLE ENGINE AND VECTOR FONT BY MARK INCITTI",40,350,1.2)	
			
			Case TitleStatus.Points
				canvas.Color=TitleColor
				VectorFont.Write(canvas,"SCORING",100,2.2)	
				
				canvas.Color=SubTitleColor
				VectorFont.Write(canvas,"SHOOT ASTEROIDS AND AVOID UFOS",120,1.2)					
				If (_counterTimer.Counter>50)  VectorFont.Write(canvas,"     20 POINTS",160,2.0)	
				If (_counterTimer.Counter>100) VectorFont.Write(canvas,"     50 POINTS",190,2.0)	
				If (_counterTimer.Counter>150) VectorFont.Write(canvas,"    100 POINTS",220,2.0)	
				If (_counterTimer.Counter>200) VectorFont.Write(canvas,"    200 POINTS",250,2.0)	
				If (_counterTimer.Counter>250) VectorFont.Write(canvas,"   1000 POINTS",280,2.0)	
		End
				
		'Display?
		canvas.Color=MessageColor
		If (Self.FlashState) VectorFont.Write(canvas,"PRESS FIRE TO PLAY",480-60,2.0)	

		'Reset
		canvas.BlendMode=BlendMode.Alpha
	End
	
Private
	Method GetScoreSummary:String(index:Int)
		'Prepare
		Local s:=Cast<Score>(HighScores.List.Get(index-1))
		If (s=Null) Return ""
		Return index+". "+("       "+s.Score).Right(7)+" "+s.Name+" "+("  "+s.Level).Right(2)
	End Method
	
End Class
