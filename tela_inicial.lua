---------------------------------------------------------------------------------
--
-- tela_inicial.lua
--
---------------------------------------------------------------------------------

local composer  = require "composer"
local scene     = composer.newScene()

---------------------------------------------------------------------------------
-- Config Global
---------------------------------------------------------------------------------

-- Configurar background
local function config_background( sceneGroup )
  local background_sheet        = require("bg_sheets")
  local background_sheet_sprite = graphics.newImageSheet( "images/bg_spritesheet.png", background_sheet:getSheet() )

  local background  = display.newImage( background_sheet_sprite , background_sheet:getFrameIndex("bg_blue1"))
  background.x      = display.contentCenterX
  background.y      = display.contentCenterY

  sceneGroup:insert( background )
end

-- Config global
local function config_global( sceneGroup )
  config_background( sceneGroup )
end


---------------------------------------------------------------------------------
-- Header
---------------------------------------------------------------------------------

-- Config header
local function config_header( sceneGroup )
  local textField = display.newText({
     text     = "Sinônimo ou Antônimo",
     x        = display.contentCenterX,
     y        = 70,
     width    = 100,
     fontSize = 20,
     align    = "center"
  })
  sceneGroup:insert( textField )
end


---------------------------------------------------------------------------------
-- Body
---------------------------------------------------------------------------------

-- Config play
local function config_play( sceneGroup )
  local function onIconTouch( self, event )

    if event.phase == "began" then
      self.alpha = 1

      composer.gotoScene( "escolher_fases", { effect = "zoomInOutFade", time = 500 } )
    elseif event.phase == "ended" or event.phase == "cancelled" then
      self.alpha = 0.25
    end

    return true
  end



  local glyphicons        = require("glyphicons")
  local glyphicons_sprite = graphics.newImageSheet("glyphicons/glyphicons_sprites.png", glyphicons:getSheet())

  local icon      = display.newImage(glyphicons_sprite, glyphicons:getFrameIndex("play_button"))
  icon.x, icon.y  = display.contentCenterX, display.contentCenterY
  icon.xScale     = 4.5
  icon.yScale     = 4.5
  icon.alpha      = 0.25
  icon.touch      = onIconTouch
  icon:addEventListener( "touch", icon )
  sceneGroup:insert( icon )

  local texto_iniciar = display.newText( "Jogar", 0, 0, native.systemFontBold, 24 )
  texto_iniciar:setFillColor( 255 )
  texto_iniciar.x, texto_iniciar.y = display.contentCenterX, display.contentCenterY
  sceneGroup:insert( texto_iniciar )
end

-- Config body
local function config_body( sceneGroup )
  config_play( sceneGroup )
end


---------------------------------------------------------------------------------
-- Footer
---------------------------------------------------------------------------------

-- Config footer
local function config_footer( sceneGroup )
  local texto_autor = display.newText( "por Igor Rocha", 0, 0, native.systemFontBold, 12 )
  texto_autor:setFillColor( 255 )
  texto_autor.x, texto_autor.y = display.contentCenterX, display.contentHeight - 20
  sceneGroup:insert( texto_autor )
end


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
        composer.removeScene( "tela_inicial", true )
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