'render layers
Const LAYER_ROCKS:Int=1
Const LAYER_BULLETS:Int=2
Const LAYER_PLAYER:Int=3
Const LAYER_PARTICLES:Int=4

Class AsteroidsState Extends GameState
Private
	Field player:PlayerEntity
	Field rockCount:Int
	Field rockSplit:Int
	Field maxRocks:Int
Public

	Method Enter:Void() Override
		Super.Enter()

		'Create/reset stuff
		CreatePlayer()
		'Rocks
		maxRocks=2
		rockSplit=2
		CreateRocks()
		
	End Method

	Method Leave:Void() Override
		Super.Leave()

		'Tidup/save stuff
		player=Null
		RemoveAllEntities()
		
	End Method
	
	Method Update:Void() Override
		Super.Update()
		
		'Keys
		If (Keyboard.KeyHit(Key.F1)) GAME.EnterState( TITLE_STATE, New TransitionFadein, New TransitionFadeout )
		If (Keyboard.KeyHit(Key.P)) GAME.Paused=Not GAME.Paused

	End Method

	'Method PreRender:Void(canvas:Canvas,tween:Double) Override
	'	Super.PreRender(canvas,tween)
	'End Method

	'Method Render:Void(canvas:Canvas,tween:Double) Override		
	'End Method
	
	'Method PostRender:Void(canvas:Canvas,tween:Double) Override
	'End Method
		
Private
	Method CreatePlayer:Void()
		player=New PlayerEntity()
		player.State=Self
		player.Reset()		
		AddEntity(player,LAYER_PLAYER)
	End Method

	Method CreateRocks:Void()
		For Local count:=0 Until maxRocks
			Local rock:=New RockEntity(Rnd(360))
			rock.SetSize(SIZE_BIG)
			rock.ResetPosition(Rnd(10,GAME.Width-10),Rnd(10,GAME.Height-10))
			AddEntity(rock,LAYER_ROCKS)
			AddEntityToGroup(rock, "rocks")
		Next
		rockCount=maxRocks
	End Method
		
End Class

