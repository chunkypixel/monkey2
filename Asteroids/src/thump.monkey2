
Global Thump:=New ThumpManager()

Const THUMP_COUNTERSTART:Int=45

Class ThumpManager
Private
	Field _currentThump:Int
	Field _channel:Channel
	Field _rate:Float=0.9
	Field _delay:CounterTimer
	Field _running:Bool=False
Public
	
	Method New()
		'Initialise
		_delay=New CounterTimer(THUMP_COUNTERSTART)
	End
	
	Method Update:Void()
		'Validate
		If (_channel=Null Or Not _running) Return
				
		'Is Playing?
		If (Not _channel.Playing And _delay.Elapsed)
			'Increment
			_currentThump=(_currentThump+1) Mod 2
			Self.Play()
		End
	End Method
	
	Method Start:Void()
		Self.Play()
		_running=True
	End Method
	
	Method Stop:Void()
		If (_channel<>Null) _channel.Stop()
		_running=False
	End
	
	Property IsRunning:Bool()
		Return _running
	End
	
Private
	Method Play:Void()
		'Prepare
		Local remainingRocks:Int=Rocks.Remaining()
		
		'Validate (sound)
		Local name:String="ThumpHi"
		If (_currentThump=1) name="ThumpLo"

		'Validate (delay)
		_delay.Interval=THUMP_COUNTERSTART
		If (remainingRocks<=15)	_delay.Interval=(THUMP_COUNTERSTART-(15-remainingRocks)*2)			
		
		'Sound
		_channel=PlaySoundEffect(name)
		_channel.Rate=_rate
		
		'Start
		_delay.Restart()
	End Method
	
End Class
