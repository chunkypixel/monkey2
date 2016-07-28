'Source
#Import "src/grid"
#Import "src/particles"
#Import "src/color"
'#Import "src/vector"
#Import "src/assets"
#Import "src/state/gamestate"
#Import "src/state/titlestate"
#Import "src/state/playstate"
'#Import "src/state/asteroidsstate"
#Import "src/entity/objectentity"
#Import "src/entity/vectorentity"
#Import "src/entity/playerentity"
#Import "src/entity/bulletentity"
#Import "src/entity/rockentity"

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
Const GAME_STATE:Int = 1

'Rocks
Const ROCK_BIG:Int=1
Const ROCK_MEDIUM:Int=2
Const ROCK_SMALL:Int=3

Function Main()
	New AppInstance
	New GridWarsGame(640,480)
	App.Run()
End Function

Class GridWarsGame Extends Game2d

	Method New(width:Int,height:int)
		Super.New("Grid Wars",width,height,WindowFlags.Resizable)

		'Initialise display
		Layout="letterbox"
		Self.GameResolution=New Vec2i(width,height)'*0.80)
		Self.ClearColor=New Color(0,0,0)
		Self.TextureFilterEnabled=False
		Style.BackgroundColor=GetColor(0,0,0)
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
		AddState( New GameState, GAME_STATE )
		'AddState( New PlayState, PLAY_STATE )
		Self.EnterTransition=New TransitionFadein
		
	End Method
	
	Method OnRestartGame:Void() Override
		EnterState( TITLE_STATE, New TransitionFadein, New TransitionFadeout )
	End Method
	
End Class
