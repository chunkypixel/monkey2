Namespace pacman

'Game
#Import "src/sprites"
#Import "src/grid"
#import "src/images"
#import "src/font"
'System
#Import "<std>"
#Import "<mojo>"

Using mojo..
Using std..

' Globals
Global window:PacmanWindow
Global DisplayOffset:=New Vec2i(0,0)

Function Main()
	New AppInstance()
	window = New PacmanWindow("Pacman",1024,768,WindowFlags.Resizable)	'Fullscreen/Resizable
	App.Run()
End

Class PacmanWindow Extends Window
	Field IsPaused:Bool
	Field IsSuspended:Bool
	Field ShowFPS:Bool=True
	Field IsDebug:Bool=False
	Field MoveGhosts:Bool=True
	Field UpdateTimer:Timer
	
	Method New(title:String, width:Int, height:Int, flags:WindowFlags)
		' Setup display
		Super.New(title, width, height, flags)
				
		'Virtual Resolution
		Layout = "letterbox"
		MinSize=New Vec2i(224,288)
		MaxSize=New Vec2i(width,height)
		ClearColor = Color.Black
		Mouse.PointerVisible=False	
		' Setup
		InitialiseSprites()
		InitialiseGrid()
		InitialiseFont()
				
		'Timer
		UpdateTimer=New Timer(120,OnUpdateTimer)
						
	End Method
		
	Method OnMeasure:Vec2i() Override
		Return New Vec2i(224,288)
	End
	
	Method OnUpdateTimer()
		'Update
		UpdateSprites()	
	End
	
	Method OnRender(canvas:Canvas) Override
		'Update
		'UpdateSprites()
		
		' Render
		App.RequestRender()
		RenderGrid(canvas)		
		RenderSprites(canvas)
		
		'Score
		canvas.Color=Color.White
		DrawFont(canvas,"1UP",24,0,Color.White)
		Local p1Score:String="      "+Pacman.Score
		DrawFont(canvas,p1Score.Right(6),8,8,Color.White)
		DrawFont(canvas,"HIGH SCORE",72,0,Color.White)
		
		'System
		If (ShowFPS) DrawFont(canvas,"FPS-" + App.FPS,0,16,Color.White)
		
	End Method
	
	Method OnKeyEvent( event:KeyEvent ) Override	
		Select event.Type
			Case EventType.KeyDown
				Select event.Key
					Case Key.F12
						Fullscreen = Not Fullscreen				
					Case Key.Escape
						App.Terminate()
					Case Key.F
						ShowFPS=Not ShowFPS
					Case Key.D
						IsDebug=Not IsDebug
					Case Key.F1
						SetGhostMode(GhostMode.Chase)
					Case Key.F2
						SetGhostMode(GhostMode.Scatter)
					Case Key.F3
						SetGhostMode(GhostMode.Frightened)
					Case Key.M
						MoveGhosts=Not MoveGhosts
					Case Key.R
						SetGhostMode(GhostMode.ReturnPen)
				End		
		End 
	End
	
	Method OnWindowEvent(event:WindowEvent) Override
		Select event.Type
			Case EventType.WindowMoved
			Case EventType.WindowResized
				App.RequestRender()
			Case EventType.WindowGainedFocus
				Self.IsSuspended = False
			Case EventType.WindowLostFocus
				Self.IsSuspended = True
			Default
				Super.OnWindowEvent(event)
		End
	End
	
End Class

Class FixedTime

	Method New()
		UpdateFrequency = 60
	End Method

	Property UpdateFrequency:Double()
		Return _updateFrequency
	Setter( value:Double )
		_updateFrequency = value
		_deltatime = 1000.0:Double / value
	End

	Property DeltaTime:Double()
		Return _deltatime
	End

	Property Tween:Double()
		Return _accumulator / _deltatime
	End

	Method Reset:Void()
		_time = Millisecs()
		_accumulator = 0
	End Method

	Method Update:Void()
		Local thistime:Double = Millisecs()
		Local passedtime:Double = thistime - _time
		_time = thistime
		_accumulator+=passedtime
	End Method


	Method TimeStepNeeded:Bool()
		If _accumulator >= _deltatime
			_accumulator-= _deltatime
			Return True
		Endif
		Return False
	End Method

	Private

	field _updateFrequency:Double
	Field _accumulator:Double
	Field _deltatime:Double
	Field _time:Double
	Field _tween:Double

End Class