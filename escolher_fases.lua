---------------------------------------------------------------------------------
--
-- tela_inicial.lua
--
---------------------------------------------------------------------------------

local composer                = require "composer"

local scene                   = composer.newScene()

local glyphicons              = require("glyphicons")

local glyphicons_sprite       = graphics.newImageSheet("glyphicons/glyphicons_sprites.png", glyphicons:getSheet())

local background_sheet        = require("spritesheet_background")

local background_sheet_sprite = graphics.newImageSheet( "images/spritesheet_background.png", background_sheet:getSheet() )

---------------------------------------------------------------------------------
-- IMPLEMENTACAO
---------------------------------------------------------------------------------

-- Variaveis local
local background, texto1, texto2, icon, myRoundedRect

function scene:create( event )
  local sceneGroup = self.view

  background   = display.newImage( background_sheet_sprite , background_sheet:getFrameIndex("cores2"))
  background.x = display.contentCenterX
  background.y = display.contentCenterY

  sceneGroup:insert( background )

  texto1 = display.newText( "Fases", 0, 0, native.systemFontBold, 20 )
  texto1:setFillColor( 255 )
  texto1.x, texto1.y = display.contentCenterX, 50

  sceneGroup:insert( texto1 )

  myRoundedRect = display.newRoundedRect( 80, 120, 50, 50, 12 )
  myRoundedRect.strokeWidth = 3
  myRoundedRect.alpha = 0.5
  myRoundedRect.text = "bla"
  myRoundedRect:setFillColor( 0.5 )
  texto2 = display.newText( "1", 0, 0, native.systemFontBold, 24 )
  texto2:setFillColor( 255 )
  texto2.x, texto2.y = myRoundedRect.x, myRoundedRect.y

  sceneGroup:insert( myRoundedRect )
  sceneGroup:insert( texto2 )
end

-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
    end
end

-- "scene:hide()"
function scene:hide( event )

    local sceneGroup  = self.view
    local phase       = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end

-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene