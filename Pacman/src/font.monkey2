Namespace pacman

#import "../images/font.png"

Private
Global _font:ImageCollection
Global _chars:String = " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@.'/-"
Public 

Function InitialiseFont()
	_font=New ImageCollection("asset::font.png",8,8)
End

Function DrawFont(canvas:Canvas,text:String,x:Int,y:Int,color:Color=Color.Red)
	'Prepare
	text=text.ToUpper()
	canvas.Color=color
	canvas.BlendMode=BlendMode.Opaque
	
	'Draw
	For Local index:=0 Until text.Length
		Local char:int=_chars.Find(text.Mid(index,1))
		If (char<>-1)
			canvas.DrawImage(_font.Item[char],DisplayOffset.X+x,DisplayOffset.Y+y)
			x+=8
		End
	Next
End
