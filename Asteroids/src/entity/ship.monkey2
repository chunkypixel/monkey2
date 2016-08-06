
Class ShipEntity Extends VectorEntity

	Method New()
		'Create
		Self.Initialise()
	End
	
	Method Initialise() Virtual
		'Points
		Self.AddPoint(-8,-8)
		Self.AddPoint(12,0)
		Self.AddPoint(-8,8)
		Self.AddPoint(-5,0)
		Self.AddPoint(-8,-8)
		
		'Other
		Self.Rotation=90.0
		Self.Scale=New Vec2f(0.75,0.75)
		
		'Reset
		Self.Reset()
	End Method

End Class

