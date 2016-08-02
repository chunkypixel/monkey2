'Source
#Import "src/settings"
#Import "src/particles"
#Import "src/thump"
#Import "src/font"
#Import "src/timer"
#Import "src/state/base"
#Import "src/state/game"
#Import "src/state/title"
#Import "src/entity/object"
#Import "src/entity/vector"
#Import "src/entity/ship"
#Import "src/entity/player"
#Import "src/entity/bullet"
#Import "src/entity/rock"
#Import "src/entity/debris"
'Assets (gfx)
#Import "assets/gfx/arcade.ttf"
#Import "assets/gfx/logo.png"
#Import "assets/gfx/particle.png"
#Import "assets/gfx/background.png"
'Assets (snd)
#Import "assets/snd/fire.wav"
#Import "assets/snd/thrust.wav"
#Import "assets/snd/explode1.wav"
#Import "assets/snd/explode2.wav"
#Import "assets/snd/explode3.wav"
#Import "assets/snd/levelup.wav"
#Import "assets/snd/thumphi.wav"
#Import "assets/snd/thumplo.wav"

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
		AddJoystickAxisControl("TURN",0)
		AddJoystickButtonControl("FIRE",1)
		AddJoystickButtonControl("THRUST",2)
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
		AddSound("Fire","asset::fire.wav")
		AddSound("Thrust","asset::thrust.wav")
		AddSound("Explode1","asset::explode1.wav")
		AddSound("Explode2","asset::explode2.wav")
		AddSound("Explode3","asset::explode3.wav")
		AddSound("LevelUp","asset::levelup.wav")
		AddSound("ThumpHi","asset::thumphi.wav")
		AddSound("ThumpLo","asset::thumplo.wav")
		
		'Create states
		AddState( New TitleState,TITLE_STATE )
		AddState( New GameState,GAME_STATE )
		Self.EnterTransition=New TransitionFadein		
	End Method
	
	Method OnRestartGame:Void() Override
		EnterState(TITLE_STATE,New TransitionFadein,New TransitionFadeout)
	End Method
	
End Class

Function GetAlpha:Float()
	Local alpha:Float=0.8
	If (VECTOR_FLICKER) alpha=Rnd(0.4,0.8)
	Return alpha
End Function

Function GetColor:Color(red:Float,green:Float,blue:Float,alpha:Float=1.0)
	Return New Color(red/255,green/255,blue/255,alpha)
End Function

Function SetImageHandle:Void(name:String,handle:Vec2f)
	Local image:=GetImage(name)
	If (image<>Null) image.Handle=handle
End Function

Function ClearEntityGroup:Void(name:String)
	Local group:=GetEntityGroup(name)
	If (group<>Null)
		For Local entity:=Eachin group.Entities
			RemoveEntity(entity)
		End
	End
End Function

Function PlaySound:Void(name:String,volume:Float,loop:Int)
End

