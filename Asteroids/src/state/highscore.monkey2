
Class HighScores
	Global List:=New Stack<Score>()
	
	Function Load:Void()
		'Prepare
		Local file:String=AppDir()+"scores.json"
		
		'Load (attempt)
		Local content:=JsonObject.Load(file)
		If (content)
			'Load scores
			Local items:=content["scores"].ToArray()
			For Local item:=Eachin items
				Local score:=item.ToString().Split(",")
				List.Add(New Score(score[0],score[1],score[2]))
			Next	
		End
		
		'Load defaults?
		If (List.Length=0)
			'Add
			List.Add(New Score("MKS",10000,3))
			List.Add(New Score("MAK",9000,3))
			List.Add(New Score("WIE",8000,2))
			List.Add(New Score("COU",7000,2))
			List.Add(New Score("ATA",6000,2))
			'Save (default)
			Save()			
		End
		
	End Function
	
	Function Save:Void()		
		'Create
		Local content:=New JsonObject()
				
		'Store
		Local items:=New JsonArray()
		For Local score:=Eachin List.All()
			items.Add(New JsonString(score.ToString()))
		Next
		content["scores"]=items
								
		'Save (attempt)
		Local s:String=AppDir()+"scores.json"
		SaveString(content.ToJson(),s)	
	End Function
	
	Function IsHighScore:Bool(score:Int)
		'Validate
		For Local s:=Eachin List.All()
			If (score>s.Score) Return True
		Next
		'No
		Return False
	End Function

	Function Insert(name:String,score:Int,level:Int)		
		'Process
		For Local index:Int=0 To List.Length-1
			'Validate
			Local s:Score=Cast<Score>(List.Get(index))
			If (score>s.Score)
				'Insert
				List.Insert(index,New Score(name,score,level))
				List.Resize(5)
				'Exit
				Return
			End
		Next
	End Function
	 
End Class

Class HighScoreState Extends StateBase
Private
	Field _entryIndex:Int
	Field _maxEntry:Int=3
	Field _charList:String="ABCDEFGHIJKLMNOPQRSTUVWXYZ "
	Field _charIndex:Int
	Field _chars:String[]
Public 

	Method Enter:Void() Override
		'Create/reset stuff
		_entryIndex=0
		_charIndex=0
		_chars=New String[3]
		
		'Starfield
		Starfield.Speed=1.5
		Starfield.Rotation=0.0
	End Method

	Method Leave:Void() Override
		'Tidup/save stuff
		
		'Get name
		Local name:string
		For Local index:Int=0 To _chars.Length-1
			name+=_chars[index]
		Next
		
		'Add name and save
		HighScores.Insert(name,Player.Score,Player.Level)
		HighScores.Save()
	End Method

	Method Update:Void() Override
		'Base
		Super.Update()
		
		'Prepare
		Local axisValue:Float=JoystickAxisValue("TURN")
		Local hatValue:JoystickHat=JoystickHatValue(0)
		
		'Cursor
		If (KeyboardControlHit("FIRE") Or JoystickButtonHit("FIRE"))
			'Store selection
			_chars[_entryIndex]=_charList.Mid(_charIndex,1)
			
			'Increment position
			_entryIndex+=1
			_charIndex=0
			
			'Exit?
			If (_entryIndex>2) Then GAME.EnterState(TITLE_STATE,New TransitionFadein,New TransitionFadeout)
		End
		
		'Letter (left)
		If (KeyboardControlHit("LEFT") Or axisValue<-0.2 Or hatValue=JoystickHat.Left)
			_charIndex-=1
			If (_charIndex<0) _charIndex=_charList.Length-1
		End
		'Letter (right)
		If (KeyboardControlHit("RIGHT") Or axisValue>0.2 Or hatValue=JoystickHat.Right)
			_charIndex+=1
			If (_charIndex>_charList.Length-1) _charIndex=0
		End
	End Method
	
	Method Render:Void(canvas:Canvas,tween:Double) Override
		'Base
		Super.Render(canvas,tween)

		'Message
		VectorFont.Write(canvas,"CONGRATULATIONS!",100,3.5)
		VectorFont.Write(canvas,"YOUR SCORE IS ONE OF THE FIVE BEST!",54,155,2.5)
		VectorFont.Write(canvas,"PLEASE ENTER YOUR INITIALS:",54,175,2.5)
		
		VectorFont.Write(canvas,"PUSH ROTATE TO CHANGE LETTER",54,VirtualResolution.Height-70,1.2)
		VectorFont.Write(canvas,"PUSH FIRE WHEN LETTER IS CORRECT",54,VirtualResolution.Height-60,1.2)
	
		'Build name and render
		Local currentName:String
		For Local index:Int=0 To _chars.Length-1
			'Get char
			Local char:String=_chars[index]
			If (char.Trim()="") char="_"
			If (index=_entryIndex) Then char=_charList.Mid(_charIndex,1)
			'Store
			currentName+=char
		Next
		VectorFont.Write(canvas,currentName,VirtualResolution.Height-150,3.5)
			
	End Method
	
End Class

Struct Score
	Field Name:String
	Field Score:Int
	Field Level:Int
	
	Method New(name:String,score:Int,level:Int)
		Self.Name=name
		Self.Score=score
		Self.Level=level
	End Method
	
	Method ToString:String()
		Return Self.Name+","+Self.Score+","+Self.Level
	End Method
End Struct