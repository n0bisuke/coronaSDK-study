--ストーリーボードの読み込み	
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

--重力を使う
local physics = require "physics"
physics.start(); --physics.pause()

-- 画面サイズの幅と高さを取得
local screenW, screenH, halfW, halfH = display.contentWidth, display.contentHeight, display.contentWidth*0.5, display.contentHeight*0.5

local scrollText = display.newText("ヨコに移動します" , 0, 0, native.systemFont, 20)
scrollText:setTextColor(0)
function animate(event)
	--オブジェクトの移動
	scrollText.x = scrollText.x + 0.5
	if(scrollText.x > screenW) then
		scrollText.x = -10
	end
	scrollText.text = "ヨコに移動します"
end

--タッチされたら呼び出される
function onTouch(event)
	--storyboard.variableName = scrollText.x
	scrollText:removeSelf()
	storyboard.gotoScene("clear",{ effect = "slideLeft", time = 500, params = { currentScore = 100}})
end

local gFlag = 0
function buttonTouch(event)--重力を反転させる
	if (gFlag == 0) then
		physics.setGravity(0,-9.8)
		gFlag = 1
	else 
		physics.setGravity(0,9.8)
		gFlag = 0
	end
end

local limitTime = 100
function enemy(event)
	limitTime = limitTime - 1
	if(limitTime == 95) then
		local enemy2 = display.newRect(50,200,40,40)
	end
	if(enemy2 == display.newRect(50,200,40,40))then
		enemy2.x = enemy2.x + 0.5
	end
end

-- シーンが作成される際に呼び出される関数
function scene:createScene( event )
	local group = self.view

	-- 背景を設定
	local background = display.newImageRect( "background.jpg", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = -400, 0
	background:scale(2,2)
	
	function animate(event)
		--オブジェクトの移動
		background.x = background.x + 1.5
		if(background.x > -50) then
			background.x = -400
		end
	end
	
	---天井を設定
	local ceiling = display.newRect(0,0,screenW,1)
	ceiling:setFillColor(255)
	physics.addBody( ceiling, "static", { friction=0.3} )

	-----落下物を作成
	local crate = display.newImageRect( "ipukun.png", 90, 90 )
	crate.x, crate.y = halfW*1.5, 10
	crate:scale(0.5,0.5)
	--crate.rotation = 15
	-- 落下物に物理属性を追加
	physics.addBody( crate, { density=1.0, friction=0.3, bounce=0.3 } )
	-- 落下物にタッチイベントを追加
	crate:addEventListener("touch",onTouch)	
	
	-- 地面
	local grass = display.newImageRect( "grass.png", screenW, 82 )
	grass:setReferencePoint( display.BottomLeftReferencePoint )
	grass.x, grass.y = 0, display.contentHeight
	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	local grassShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	physics.addBody( grass, "static", { friction=0.3, shape=grassShape } )
	grass:addEventListener("touch",buttonTouch)

	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( grass)
	group:insert( crate )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	--アニメーション用
	Runtime:addEventListener("enterFrame", animate)
	timer.performWithDelay(1000, enemy, 0)	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	Runtime:removeEventListener("enterFrame", animate) --animate終了
	physics.stop()
	storyboard.removeScene('level1') --シーンの情報を削除します． 2週目に響くので
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	--storyboard.removeScene('level1')
	package.loaded[physics] = nil
	physics = nil
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene