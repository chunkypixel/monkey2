
Function GetAlpha:Float()
	Local alpha:Float=0.8
	If (VECTOR_FLICKER) alpha=Rnd(0.5,0.9)
	Return alpha
End Function

Function GetLineWidth:Float(width:Float)
	Return Min(3.5,width*VirtualResolution.Best)
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

Function PlaySoundEffect:Channel(name:String,volume:Float=0.25,rate:Float=1.0,loop:Bool=False)
	Local channel:=GAME.PlaySound(name,loop)
	channel.Volume=volume
	channel.Rate=rate
	Return channel
End

Function InExclusionZone:Bool(entity:Entity)
	Return InExclusionZone(entity.Position) 		
End Function
Function InExclusionZone:Bool(position:Vec2f)
	Return (position.X>VirtualResolution.Width/2-120 And position.X<VirtualResolution.Width/2+120 And position.Y>VirtualResolution.Height/2-100 And position.Y<VirtualResolution.Height/2+100) 		
End	Function

Function GetScreenSize:Vec2i()
	Local width:Int=1024
	Local height:Int=768
	
	'Validate
	Select SCREEN_WIDTH
		Case 640
			width=640
			height=480
		Case 800
			width=800
			height=600
		Case 1366
			width=1366
			height=768
		Case 1920
			width=1920
			height=1080
	End
	
	'Return
	Return New Vec2i(width,height)
End
