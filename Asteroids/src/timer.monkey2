
Global Timers:=New List<CounterTimer>

Function UpdateCounterTimers:Void()
	For Local ct:=Eachin Timers
		ct.Update()
	Next
	
End Function

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
	
	Method Reset:Void()
		_counter=0
		Self.Enabled=True
		Self.Elapsed=False
	End
	
	Method Start:Void()
		Self.Enabled=True
	End
	
	Method Stop:Void()
		Self.Enabled=False
	End
End Class
