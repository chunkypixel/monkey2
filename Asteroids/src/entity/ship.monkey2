Global ShipLives:ShipEntity

Class ShipEntity Extends VectorEntity

	Method New()
		'Initialise
		Self.Initialise()
	End
	
	Method Initialise:Void() Virtual
		'Points
		Self.CreatePoint(-8,-8)
		Self.CreatePoint(12,0)
		Self.CreatePoint(-8,8)
		Self.CreatePoint(-5,0)
		Self.CreatePoint(-8,-8)
		
		'Other
		Self.Rotation=90.0
		Self.Scale=New Vec2f(0.75,0.75)
		
		'Reset
		Self.Reset()
	End Method

End Class

