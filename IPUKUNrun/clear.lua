--ストーリーボード読み込み
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- 画面サイズの幅と高さを取得
local screenW, screenH, halfW, halfH = display.contentWidth, display.contentHeight, display.contentWidth*0.5, display.contentHeight*0.5

local currentScore

--シーンがタッチされた時に呼び出される
function onTouch(event)
	storyboard.gotoScene("menu", "fade", 500)
end

-- シーンが表示された際に呼び出される関数
function scene:createScene( event )
	local group = self.view

	-- 背景作成
	local bg = display.newRect( 0, 0, screenW, screenH )
	bg:setFillColor(160)
	
	local text = display.newText("クリアー", 0,0, native.systemFont,32)
	text:setTextColor(0)
	text.x = display.contentWidth * 0.5
	text.y = 125

	group:addEventListener("touch", onTouch)
	group:insert(bg)
	group:insert(text)
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	currentScore = event.params.currentScore
	print( "Got currentScore = " .. currentScore )
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
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