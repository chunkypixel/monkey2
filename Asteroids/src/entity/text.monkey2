
Class ExplodingText
	
	Function Create:Void(position:Vec2f,text:string)
		Local explodingText:=New TextEntity(position,text)
		AddEntity(explodingText,LAYER_OTHER,"text")
	End Function
	
	Function Remove:Void()
		ClearEntityGroup("text")	
	End Function

End Class

Class TextEntity Extends ObjectEntity
Private
	Field _text:String
	Field _explode:Float=0.08
	Field _fader:Float=0.05
	Field _scale:Float=0.8
Public
	Field Alpha:Float=1.0
	
	Method New(position:Vec2f,text:String)
		Self.Initialise(text)
		Self.ResetPosition(position.X, position.Y)
	End Method
	
	Method Update:Void() Override
		'Increase size
		_scale+=_explode
				
		'Fade alpha and remove when finished
		If (_scale>2.0) Self.Alpha-=_fader
		If (Self.Alpha<=0) RemoveEntity(Self)
	End Method
	
	Method Render:Void(canvas:Canvas) Override
		'Canvas
		canvas.Color=Self.Color
		
		'Get central postion
		Local length:Float=VectorFont.Length(_text.Length,_scale)
		
		'Draw 
		VectorFont.Write(canvas,_text,Self.Position.x-length/2,Self.Position.y,_scale,Self.Alpha)
	End Method
		
Private
	Method Initialise:Void(text:String)
		_text=text
		
		'Other
		Self.Scale=New Vec2f(0.5,0.5)
		Self.Color=MessageColor
		Self.Alpha=1.0
		
	End Method
		
End Class
