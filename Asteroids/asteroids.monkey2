'Source
#Import "src/particles"
#Import "src/font"
#Import "src/state/game"
#Import "src/state/title"
#Import "src/entity/object"
#Import "src/entity/vector"
#Import "src/entity/player"
#Import "src/entity/bullet"
#Import "src/entity/rock"

'Assets
#Import "assets/gfx/arcade.ttf"
#Import "assets/gfx/logo.png"
#Import "assets/gfx/particle.png"
#Import "assets/gfx/background.png"

'System
#Import "<std>"
#Import "<mojo>"
#Import "<game2d>"
Using std..
Using mojo..
Using wdw.game2d

'Game states
Const TITLE_STATE:Int = 0
Const GAME_STATE:Int = 1

'Rocks
Const ROCK_BIG:Int=1
Const ROCK_MEDIUM:Int=2
Const ROCK_SMALL:Int=3

Function Main()
	New AppInstance
	New AsteroidsGame(640,480)
	App.Run()
End Function

Class AsteroidsGame Extends Game2d

	Method New(width:Int,height:int)
		Super.New("Asteroids",width,height,WindowFlags.Resizable)

		'Initialise display
		Self.Layout="stretch"
		Self.GameResolution=New Vec2i(width,height)
		Self.ClearColor=New Color(0,0,0)
		Self.TextureFilterEnabled=False
		Style.BackgroundColor=GetColor(0,0,0)
		Style.DefaultFont=Font.Load("asset::arcade.ttf",10)
		
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
		AddJoystickAxisControl( "TURN", 0 )
		AddJoystickButtonControl( "FIRE", 1 )
		AddJoystickButtonControl( "THRUST", 2 )
		' apply loaded input settings to the input manager.
		' this will override the controls defined above;
		' they will be removed and the ones in the configuration will be added.
		ApplyInputConfiguration()

		'Add images
		AddImage("Logo","asset::logo.png")
		SetImageHandle("Logo",New Vec2f(0.5,0.0))
		AddImage("Particle","asset::particle.png")
		SetImageHandle("Particle",New Vec2f(0.5,0.5))
		AddImage("Background","asset::background.png")
		SetImageHandle("Background",New Vec2f(0.5,0.5))

		'Add sounds
		
		'Create states
		AddState( New TitleState,TITLE_STATE )
		AddState( New GameState,GAME_STATE )
		Self.EnterTransition=New TransitionFadein
		
	End Method
	
	Method OnRestartGame:Void() Override
		EnterState( TITLE_STATE,New TransitionFadein,New TransitionFadeout )
	End Method
	
End Class


Function GetColor:Color(red:Float,green:Float,blue:Float)
	Return New Color(red/255,green/255,blue/255)
End Function

Function SetImageHandle(name:String,handle:Vec2f)
	Local image:=GetImage(name)
	If (image<>Null) image.Handle=handle
End Function
