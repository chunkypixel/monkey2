'Source
#Import "src/functions"
#Import "src/scaler"
#Import "src/settings"
#Import "src/starfield"
#Import "src/particles"
#Import "src/thump"
#Import "src/font"
#Import "src/timer"
#Import "src/state/base"
#Import "src/state/title"
#Import "src/state/game"
#Import "src/state/highscore"
#Import "src/entity/object"
#Import "src/entity/vector"
#Import "src/entity/ship"
#Import "src/entity/player"
#Import "src/entity/ufo"
#Import "src/entity/bullet"
#Import "src/entity/rock"
#Import "src/entity/debris"
'Assets (gfx)
#Import "assets/gfx/arcade.ttf"
#Import "assets/gfx/particle.png"
'Assets (snd)
#Import "assets/snd/appear.wav"
#Import "assets/snd/fire.wav"
#Import "assets/snd/thrust.wav"
#Import "assets/snd/explode1.wav"
#Import "assets/snd/explode2.wav"
#Import "assets/snd/explode3.wav"
#Import "assets/snd/levelup.wav"
#Import "assets/snd/thumphi.wav"
#Import "assets/snd/thumplo.wav"
#Import "assets/snd/lsaucer.wav"
#Import "assets/snd/ssaucer.wav"

'System
#Import "<std>"
#Import "<mojo>"
#Import "<game2d>"
Using std..
Using mojo..
Using wdw.game2d

'Game states
Const TITLE_STATE:Int=0
Const GAME_STATE:Int=1
Const HIGHSCORE_STATE:Int=2

'Game layers
Const LAYER_CAMERA:Int=0
Const LAYER_ROCKS:Int=1
Const LAYER_UFO:Int=2
Const LAYER_BULLETS:Int=3
Const LAYER_PLAYER:Int=4
Const LAYER_DEBRIS:Int=5

Const TITLE:String="ASTEROIDS 2K"
Const VERSION:String="0.5 10.08.2016"

Function Main()
	New AppInstance
	
	'Settings
	Settings.Load()
	Settings.Save()
	
	'Create game
	Local screenSize:Vec2i=GetScreenSize()
	New AsteroidsGame(screenSize.x,screenSize.y)
	
	'Run
	App.Run()
End Function

Class AsteroidsGame Extends Game2d

	Method New(width:Int,height:Int)
		Super.New(TITLE,width,height,WindowFlags.Resizable)
				
		'Initialise display
		Self.Layout="stretch"
		Self.GameResolution=New Vec2i(width,height)
		Self.ClearColor=New Color(0,0,0)
		Self.TextureFilterEnabled=False
		Self.VSync=VSYNC
		Style.BackgroundColor=GetColor(0,0,0)
		Style.DefaultFont=Font.Load("asset::arcade.ttf",10)
		
		'Virtual resolution
		'Internally display run @ 640x480
		VirtualResolution=New ResolutionScaler(width,height)
				
		'Debugger
		Self.Debug=False
		Mouse.PointerVisible=False
		
		'Randomise
		SeedRnd(Millisecs())
		
		'Configure controls
		'Keyboard
		AddKeyboardControl("LEFT",Key.Left)
		AddKeyboardControl("RIGHT",Key.Right)
		AddKeyboardControl("THRUST",Key.Up)
		AddKeyboardControl("FIRE",Key.LeftControl)
		'Joystick
		AddJoystickAxisControl("TURN",0)
		AddJoystickButtonControl("FIRE",1)
		AddJoystickButtonControl("THRUST",2)
		' apply loaded input settings to the input manager.
		' this will override the controls defined above;
		' they will be removed and the ones in the configuration will be added.
		ApplyInputConfiguration()

		'Add images
		AddImage("Particle","asset::particle.png")
		SetImageHandle("Particle",New Vec2f(0.5,0.5))

		'Add sounds
		AddSound("Appear","asset::appear.wav")
		AddSound("Fire","asset::fire.wav")
		AddSound("Thrust","asset::thrust.wav")
		AddSound("Explode1","asset::explode1.wav")
		AddSound("Explode2","asset::explode2.wav")
		AddSound("Explode3","asset::explode3.wav")
		AddSound("LevelUp","asset::levelup.wav")
		AddSound("ThumpHi","asset::thumphi.wav")
		AddSound("ThumpLo","asset::thumplo.wav")
		AddSound("LSaucer","asset::lsaucer.wav")
		AddSound("SSaucer","asset::ssaucer.wav")
		
		'Create states
		AddState(New TitleState,TITLE_STATE)
		AddState(New GameState,GAME_STATE)
		AddState(New HighScoreState,HIGHSCORE_STATE)
		Self.EnterTransition=New TransitionFadein		
	End Method
	
	Method OnRestartGame:Void() Override
		EnterState(TITLE_STATE,New TransitionFadein,New TransitionFadeout)
	End Method
	
End Class

