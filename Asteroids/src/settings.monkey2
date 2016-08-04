
Global MAX_LIVES:Int=3
Global VECTOR_FLICKER:Bool=True
Global BACKGROUND_IMAGE:Bool=True
Global SHAKE_ON_EXPLOSION:Bool=True

Function LoadSettings:Void()
	'Prepare
	Local fileName:String=AppDir()+"settings.json"
	
	'Load (attempt)
	Local settings:=JsonObject.Load(fileName)
	If (settings)
		MAX_LIVES=settings["lives"].ToInt()
		VECTOR_FLICKER=settings["flicker"].ToBool()
		BACKGROUND_IMAGE=settings["backgroundimage"].ToBool()
		SHAKE_ON_EXPLOSION=settings["shake"].ToBool()
	End
End Function

Function SaveSettings:Void()
	'Create
	Local settings:=New JsonObject()
	settings["lives"] = New JsonNumber(MAX_LIVES)
	settings["flicker"] = New JsonBool(VECTOR_FLICKER)
	settings["backgroundimage"] = New JsonBool(BACKGROUND_IMAGE)
	settings["shake"] = New JsonBool(SHAKE_ON_EXPLOSION)
	
	'Save (attempt)
	Local s:String=AppDir()+"settings.json"
	SaveString(settings.ToJson(),s)
End Function

