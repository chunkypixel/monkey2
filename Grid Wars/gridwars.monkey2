'Source
#Import "src/grid"
#Import "src/particles"
#Import "src/color"
#Import "src/vector"
#Import "src/assets"
#Import "src/state/gamestate"
#Import "src/state/titlestate"
#Import "src/state/playstate"
#Import "src/state/asteroidsstate"
#Import "src/entities/player"
#Import "src/entities/bullet"
#Import "src/entities/rock"
#Import "<std>"
#Import "<mojo>"
#Import "<game2d>"
'System
Using std..
Using mojo..
Using wdw.game2d

'Game states
Const TITLE_STATE:Int = 0
Const PLAY_STATE:Int = 1
Const ASTEROIDS_STATE:Int = 1

'Rocks
Const SIZE_BIG:Int = 2
Const SIZE_MEDIUM:Int = 3
Const SIZE_SMALL:Int = 4

Function Main()
	New AppInstance
	New GridWarsGame(800,600)
	App.Run()
End Function

Class GridWarsGame Extends Game2d

	Method New(width:Int,height:int)
		Super.New("Grid Wars",width,height,WindowFlags.Resizable)

		'Initialise display
		Layout="letterbox"
		Self.GameResolution=New Vec2i(width,height*0.80)
		Self.ClearColor=New Color(0,0,0)
		Self.TextureFilterEnabled=False
		Style.BackgroundColor=New Color(0,0,0)
		Style.DefaultFont=Font.Load("asset::arcade.ttf",10)
		VSync=False
		
		'Debugger
		Self.Debug=False
		Mouse.PointerVisible=False
		
		'Randomise
		SeedRnd(Millisecs())
		
		'Images
		InitialiseImages()
		
		'Configure controls
		'Keyboard
		AddKeyboardControl("LEFT",Key.Left)
		AddKeyboardControl("RIGHT",Key.Right)
		AddKeyboardControl("THRUST",Key.Up)
		AddKeyboardControl("FIRE",Key.LeftControl)
		'Joystick
		AddJoystickAxisControl( "TURN", 0 )
		AddJoystickButtonControl( "FIRE", 1 )
		AddJoystickButtonControl( "THRUST", 2 )
		' apply loaded input settings to the input manager.
		' this will override the controls defined above;
		' they will be removed and the ones in the configuration will be added.
		ApplyInputConfiguration()

		'add sounds, give easy to remember names.
		'AddSound( "asset::bullet.wav", "bullet" )
		
		'Create states
		AddState( New TitleState, TITLE_STATE )
		AddState( New AsteroidsState, ASTEROIDS_STATE )
		'AddState( New PlayState, PLAY_STATE )
		Self.EnterTransition=New TransitionFadein
		
	End Method

End Class
