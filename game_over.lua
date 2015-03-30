---------------------------------------------------------------------------------
--
-- game_over.lua
--
---------------------------------------------------------------------------------

local composer  = require "composer"
local scene     = composer.newScene()

local background_sheet        = require("bg_sheets")
local background_sheet_sprite = graphics.newImageSheet( "images/bg_spritesheet.png", background_sheet:getSheet() )

---------------------------------------------------------------------------------
-- Config Global
---------------------------------------------------------------------------------

-- Config background
---------------------------------------------------------------------------------
local function config_background( sceneGroup )
  local background  = display.newImage( background_sheet_sprite , background_sheet:getFrameIndex("bg_blue1"))
  background.x      = centerX
  background.y      = centerY

  sceneGroup:insert( background )
end

-- Config global
---------------------------------------------------------------------------------
local function config_global( sceneGroup )
  config_background( sceneGroup )
end


---------------------------------------------------------------------------------
-- Header
---------------------------------------------------------------------------------

-- Config header
---------------------------------------------------------------------------------
local function config_header( sceneGroup )
end


---------------------------------------------------------------------------------
-- Body
---------------------------------------------------------------------------------

-- Config body
---------------------------------------------------------------------------------
local function config_body( sceneGroup )
  local texto_game_over = display.newText( "Game Over", 0, 0, native.systemFontBold, 24 )
  texto_game_over:setFillColor( 255 )
  texto_game_over.xScale, texto_game_over.yScale = 0, 0
  texto_game_over.x, texto_game_over.y = centerX, centerY - 100
  transition.to(texto_game_over, { time = 1800, delay = 800,xScale = 2.0, yScale = 2.0, transition = easing.outElastic })
  sceneGroup:insert( texto_game_over )

  local function onIconTouch( self, event )
    if event.phase == "began" then
      audio.play( popSound )

      composer.gotoScene( "escolher_fases", { effect = "zoomInOutFade", time = 500 } )
    elseif event.phase == "ended" or event.phase == "cancelled" then
      self.alpha = 0.25
    end

    return true
  end

  local disk_red      = display.newImage("images/puck_red.png")
  disk_red.x, disk_red.y  = centerX, centerY
  disk_red.touch      = onIconTouch
  disk_red:addEventListener( "touch", disk_red )
  sceneGroup:insert( disk_red )

  local texto_iniciar = display.newText( "Jogar", 0, 0, native.systemFontBold, 24 )
  texto_iniciar:setFillColor( 255 )
  texto_iniciar.x, texto_iniciar.y = disk_red.x, disk_red.y
  sceneGroup:insert( texto_iniciar )
end


---------------------------------------------------------------------------------
-- Footer
---------------------------------------------------------------------------------

-- Config footer
---------------------------------------------------------------------------------
local function config_footer( sceneGroup )
end

-- "scene:create()"
function scene:create( event )
  local sceneGroup = self.view

  config_global( sceneGroup )

  config_header( sceneGroup )

  config_body( sceneGroup )

  config_footer( sceneGroup )
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