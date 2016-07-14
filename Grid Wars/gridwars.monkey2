'Source
#Import "src/grid"
#Import "src/particles"
#Import "src/color"
#import "src/assets"
#Import "src/state/titlestate"
#Import "src/state/playstate"
#Import "<std>"
#Import "<mojo>"
#Import "<game2d>"
'System
Using std..
Using mojo..
Using game2d

'Game states
Const TITLE_STATE:Int = 0
Const PLAY_STATE:Int = 1

Function Main()
	New AppInstance
	New GridWarsGame
	App.Run()
End Function

Class GridWarsGame Extends Game2d

	Method New()
		Super.New("Grid Wars",640,480,WindowFlags.Resizable)

		Layout="letterbox"
		Self.GameResolution=New Vec2i(640,480)
		Self.ClearColor=New Color(0,0,0)
		Mouse.PointerVisible=True
		Style.BackgroundColor=New Color(0,0,0)
		Style.DefaultFont=Font.Load("asset::arcade.ttf",10)
		
		Self.Debug=True

		SeedRnd(Millisecs())

		AddKeyControl("LEFT",Key.Left)
		AddKeyControl("RIGHT",Key.Right)
		AddKeyControl("FIRE",Key.LeftControl)

		'set global image
		'images=Self.GrabAnimation(Image.Load("asset::rocks.png"),16,16,6)

		'add sounds, give easy to remember names.
		'AddSound( "asset::bullet.wav", "bullet" )
		'AddSound( "asset::explosion.wav", "explosion" )
		'AddSound( "asset::stageup.wav", "levelup" )
		'AddSound( "asset::warp.wav", "warp" )

		AddState( New PlayState, PLAY_STATE )
		AddState( New TitleState, TITLE_STATE )
		Self.EnterTransition=New TransitionFadein
		
	End Method

End Class
