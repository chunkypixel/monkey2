Namespace pacman

Class ImageCollection

private
	Field _images:Image[]
		
Public
	Method New(imageName:string,width:Int,height:Int,textureFlags:TextureFlags=TextureFlags.Mipmap)
		'Prepare
		Local imageStrip:=Image.Load(imageName,textureFlags)
		local count:Int=imageStrip.Width/width
		
		'Load images
		_images=New Image[count]
		For Local index:=0 Until count
			'Prepare
			Local x:int=index*width
			
			'Grab
			Local newImage:=New Image(imageStrip,New Recti(x,0,x+width,height))
			'newImage.Handle=New Vec2f( handleX,handleY )
			_images[index]=newImage
			
		Next	
	
	End

	Property Item:Image[]() 
		Return _images
	End
	
	Property Count:Int()
		Return _images.Length
	End
End