
'Application
#Import "src/grid"
'System
#Import "<std>"
#Import "<mojo>"

Using mojo..
Using std..

' Globals
Global window:MainWindow
Global DisplayOffset:=New Vec2i(0,0)

global sz:Int=64
Global amnt:Float=10

Function Main()
	New AppInstance()
	window = New MainWindow("The Grid",640,480,WindowFlags.Fullscreen)	'Fullscreen/Resizable
	App.Run()
End

Class MainWindow Extends Window
Private
	Field _gridStyle:Int=0
	Field _gridAnimation:Int=0
Public
	Field IsPaused:Bool
	Field IsSuspended:Bool
	Field ShowFPS:Bool=True
	Field Grid:WonderGrid

	Method New(title:String, width:Int, height:Int, flags:WindowFlags)
		' Setup display
		Super.New(title, width, height, flags)
				
		'Virtual Resolution
		'Layout = "letterbox"
		MinSize=New Vec2i(640,480)
		MaxSize=New Vec2i(width,height)
		ClearColor = Color.Black
		Mouse.PointerVisible=True	
		
		'Initialise
		Grid=New WonderGrid(width,height)
		'Grid.Size=GridSize.Small	
	End Method
		
	Method OnRender(canvas:Canvas) Override
		'Interaction
		'If (Keyboard.KeyDown(Key.F1)) Grid.Shockwave(Mouse.X,Mouse.Y)
		'If (Keyboard.KeyDown(Key.F2)) Grid.BombShockwave(Mouse.X,Mouse.Y)
		'If (Keyboard.KeyDown(Key.F3)) Grid.Pull(Mouse.X,Mouse.Y,sz,amnt)
		'If (Keyboard.KeyDown(Key.F4)) Grid.Push(Mouse.X,Mouse.Y,sz,amnt/4)
		
		'Change style and animation state
		If (Keyboard.KeyReleased(Key.S)) _gridStyle=(_gridStyle+1) Mod 7
		If (Keyboard.KeyReleased(Key.A)) _gridAnimation=(_gridAnimation+1) Mod 4
		
		'Fire
		If (Mouse.ButtonDown(MouseButton.Left))
			Select _gridAnimation
				Case 0
					Grid.Shockwave(Mouse.X,Mouse.Y)
				Case 1
					Grid.BombShockwave(Mouse.X,Mouse.Y)
				Case 2
					Grid.Pull(Mouse.X,Mouse.Y,sz,amnt)
				Case 3
					Grid.Push(Mouse.X,Mouse.Y,sz,amnt/4)
			End
		End
		
		' Update
		Grid.Update()
		
		' Render
		App.RequestRender()
		Grid.Render(canvas,_gridStyle)		
		
		'System
		canvas.Color=Color.White
		If (ShowFPS) canvas.DrawText("FPS:"+App.FPS,0,0)
		canvas.DrawText("Style:"+_gridStyle,0,15)
		canvas.DrawText("Animation:"+_gridAnimation,0,30)
		
	End
	
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
