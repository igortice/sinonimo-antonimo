---------------------------------------------------------------------------------
--
-- tela_inicial.lua
--
---------------------------------------------------------------------------------

local composer          = require "composer"

local scene             = composer.newScene()

local glyphicons        = require("glyphicons")

local glyphicons        = require("glyphicons")

local glyphicons_sprite = graphics.newImageSheet("glyphicons/glyphicons_sprites.png", glyphicons:getSheet())

---------------------------------------------------------------------------------
-- IMPLEMENTACAO
---------------------------------------------------------------------------------

-- Variaveis local
local background, texto_iniciar, icon

function scene:create( event )
  local sceneGroup = self.view

  background   = display.newImage( "images/furacao.png" )
  background.x = display.contentCenterX
  background.y = display.contentCenterY

  sceneGroup:insert( background )

  texto_iniciar = display.newText( "Escolher Fases", 0, 0, native.systemFontBold, 24 )
  texto_iniciar:setFillColor( 255 )
  texto_iniciar.x, texto_iniciar.y = display.contentCenterX, display.contentCenterY

  sceneGroup:insert( texto_iniciar )
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