
Global Timers:=New TimerManager()

Class TimerManager
Private
	Field _timers:List<CounterTimer>
Public
	Method New()
		'Initialise
		Self.Initialise()
	End Method
	
	Method Update:Void()
		For Local timer:=Eachin _timers
			timer.Update()
		Next	
	End Method
	
	Method Add:Void(timer:CounterTimer)
		_timers.Add(timer)
	End Method
	
Private
	Method Initialise:Void()
		'Initialise
		_timers=New List<CounterTimer>
	End Method
	
End Class

Class CounterTimer
Private
	Field _counter:Int=0
Public
	Field Interval:Int=50 
	Field Enabled:Bool=True
	Field Elapsed:Bool=False
	Field Loop:Bool=False
	
	Method New(interval:Int,enabled:Bool=True,loop:Bool=False)
		Self.Interval=interval
		Self.Enabled=enabled
		Self.Loop=loop
		Timers.Add(Self)
	End Method
	
	Method Update:Void()
		If (Self.Enabled) 
			_counter+=1
			If (_counter>=Self.Interval)
				Self.Enabled=False
				Self.Elapsed=True
			End
		End
	End
	
	Method Restart:Void()
		_counter=0
		Self.Enabled=True
		Self.Elapsed=False
	End
	
	Method Start:Void()
		Self.Enabled=True
	End
	
	Method Stop:Void()
		_counter=0
		Self.Enabled=False
		Self.Elapsed=False
	End
	
	Property Counter:Int()
		Return _counter
	End
	
	Property IsRunning:Bool()
		Return (Self.Enabled Or Self.Elapsed)
	End
End Class
