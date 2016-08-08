
Global MAX_LIVES:Int=3
Global VECTOR_FLICKER:Bool=True
Global SHAKE_ON_EXPLOSION:Bool=True
Global SCREEN_WIDTH:Int=1024

Function LoadSettings:Void()
	'Prepare
	Local fileName:String=AppDir()+"settings.json"
	
	'Load (attempt)
	Local settings:=JsonObject.Load(fileName)
	If (settings)
		SCREEN_WIDTH=settings["screenwidth"].ToInt()
		MAX_LIVES=settings["lives"].ToInt()
		VECTOR_FLICKER=settings["flicker"].ToBool()
		SHAKE_ON_EXPLOSION=settings["shake"].ToBool()
	End
End Function

Function SaveSettings:Void()
	'Create
	Local settings:=New JsonObject()
	settings["screenwidth"] = New JsonNumber(SCREEN_WIDTH)
	settings["lives"] = New JsonNumber(MAX_LIVES)
	settings["flicker"] = New JsonBool(VECTOR_FLICKER)
	settings["shake"] = New JsonBool(SHAKE_ON_EXPLOSION)
	
	'Save (attempt)
	Local s:String=AppDir()+"settings.json"
	SaveString(settings.ToJson(),s)
End Function

