
'Assets
#Import "../assets/gfx/arcade.ttf"
#Import "../assets/gfx/logo.png"
#Import "../assets/gfx/player.png"
#Import "../assets/gfx/yellowshot.png"
#Import "../assets/gfx/astdelux.blur.png"

Global LogoImage:Image
Global PlayerImage:Image
Global BulletImage:Image
Global BackgroundImage:Image

Function InitialiseImages()
	LogoImage=Image.Load("asset::logo.png",TextureFlags.Filter)
	DebugAssert(LogoImage<>Null,"logo not loaded!!")
	LogoImage.Handle=New Vec2f(0.5,0)

	PlayerImage=Image.Load("asset::player.png",TextureFlags.Filter)
	DebugAssert(PlayerImage<>Null,"player not loaded!!")
	PlayerImage.Handle=New Vec2f(0.5,0.5)
	
	PlayerImage=Image.Load("asset::player.png",TextureFlags.Filter)
	DebugAssert(PlayerImage<>Null,"player not loaded!!")
	PlayerImage.Handle=New Vec2f(0.5,0.5)
	
	BulletImage=Image.Load("asset::yellowshot.png",TextureFlags.Filter)
	DebugAssert(BulletImage<>Null,"bullet not loaded!!")
	BulletImage.Handle=New Vec2f(0.5,0.5)
	
	BackgroundImage=Image.Load("asset::astdelux.blur.png",TextureFlags.Filter)
	DebugAssert(BackgroundImage<>Null,"background not loaded!!")
	BackgroundImage.Handle=New Vec2f(0.0,0.0)
End Function

