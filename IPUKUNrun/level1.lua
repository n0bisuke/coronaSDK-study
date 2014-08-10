--ストーリーボードの読み込み	
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

--重力を使う
local physics = require "physics"
physics.start(); --physics.pause()

-- 画面サイズの幅と高さを取得
local screenW, screenH, halfW, halfH = display.contentWidth, display.contentHeight, display.contentWidth*0.5, display.contentHeight*0.5
local limitTime = 100 --制限時間
local crate = display.newImageRect( "kuma.png", 90, 90 )

--敵を作る
function createEnemy(event)
	local group = display.newGroup()
	group:insert(display.newRect(screenW*0.8,math.random(300),4,4))
end

--時間経過を管理
function timeCheck(event)
	limitTime = limitTime - 1
end

local scrollText = display.newText("ヨコに移動します" , 0, 0, native.systemFont, 20)
scrollText:setTextColor(255)
function animate(event)
	--オブジェクトの移動
	scrollText.x = scrollText.x + 0.5
	if(scrollText.x > screenW) then
		scrollText.x = -10
	end
	scrollText.text = "ヨコに移動します"..limitTime
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


function enemy(event)
	limitTime = limitTime - 1
	if(limitTime == 95) then
		enemyObj = display.newRect(50,200,40,40)
		physics.addBody(enemyObj)
	end
	if(enemyObj == display.newRect(50,200,40,40))then
		enemyObj.x = enemyObj.x - 0.5
	end
end

--右に移動
function moveRight(event)
	if event.phase == "moved" then
		crate.x = crate.x + 10
	end
end

--上に移動
function moveUp(event)
	--crate.y = crate.y - 50
	physics.setGravity(0,-9.8)
end

--下に移動
function moveDown(event)
	--crate.y = crate.y - 50
	physics.setGravity(0,9.8)
end


-- シーンが作成される際に呼び出される関数
function scene:createScene( event )
	local group = self.view

	-- 背景を設定
	local background = display.newImageRect( "background.jpg", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = -400, 0
	background:scale(2,2)
	
	function animateBg(event)
		local speed = -3
		local startPoint = screenW*0.1-100
		background.x = background.x + speed
		if(background.x < (startPoint - screenW)) then
			background.x = startPoint
		end
	end

	---天井を設定
	local ceiling = display.newRect(-50,0,screenW,1)
	ceiling:setFillColor(255)
	physics.addBody( ceiling, "static", { friction=0.3} )

	-----落下物を作成
	crate.x, crate.y = 0, 10
	--crate:scale(0.5,0.5)
	crate.rotation = 70
	-- 落下物に物理属性2追加
	physics.addBody( crate, { density=1.0, friction=0.3, bounce=0.3 } )
	-- 落下物にタッチイベントを追加
	crate:addEventListener("touch",onTouch)	

	------------キーボード-------
	local keyboard = display.newGroup()
	keyboard:insert(display.newRect(screenW*0.4,50,10,10)) --右
	keyboard:insert(display.newRect(screenW*0.3,50,10,10)) --左
	keyboard:insert(display.newRect(screenW*0.35,30,10,10)) --上
	keyboard:insert(display.newRect(screenW*0.35,70,10,10)) --下	
	keyboard[1]:addEventListener("touch",moveRight)
	--keyboard[2]:addEventListener("tap",moveLeft)
	keyboard[3]:addEventListener("touch",moveUp)
	keyboard[4]:addEventListener("touch",moveDown)
	

	-- 地面
	local grass = display.newImageRect( "grass.png", screenW, 82 )
	grass:setReferencePoint( display.BottomLeftReferencePoint )
	grass.x, grass.y = -50, display.contentHeight
	grass:scale(2,1)
	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	--local grassShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	physics.addBody( grass, "static", { friction=0.3} )
	grass:addEventListener("tap",buttonTouch)

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
	Runtime:addEventListener("enterFrame", animateBg)
	--timer.performWithDelay(1000, enemy, 0)
	timer.performWithDelay(1000, createEnemy, 0)
	timer.performWithDelay(1000, timeCheck, 0)
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