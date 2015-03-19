---------------------------------------------------------------------------------
--
-- escolher_fases.lua
--
---------------------------------------------------------------------------------

local composer  = require "composer"
local scene     = composer.newScene()

---------------------------------------------------------------------------------
-- Config Global
---------------------------------------------------------------------------------

-- Configurar background
local function config_background( sceneGroup )
  local background_sheet        = require("spritesheet_background")
  local background_sheet_sprite = graphics.newImageSheet( "images/spritesheet_background.png", background_sheet:getSheet() )

  local background  = display.newImage( background_sheet_sprite , background_sheet:getFrameIndex("cores2"))
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
  local texto_head        = display.newText( "Fases", 0, 0, native.systemFontBold, 20 )
  texto_head.x, texto_head.y  = display.contentCenterX, 50
  texto_head:setFillColor( 255 )
  sceneGroup:insert( texto_head )
end


---------------------------------------------------------------------------------
-- Body
---------------------------------------------------------------------------------

-- Config diplay fases body
local function config_display_fases( sceneGroup )
  local function onFaseTouch( self, event )

    if event.phase == "began" then
      self.alpha = 1

      composer.gotoScene( "fase", { effect = "slideLeft", time = 800 } )
    elseif event.phase == "ended" or event.phase == "cancelled" then
      self.alpha = 0.25
    end

    return true
  end

  local numero_fase = 1

  local retangulo       = display.newRoundedRect( 80, 120, 50, 50, 12 )
  retangulo.strokeWidth = 3
  retangulo.alpha       = 0.5
  retangulo.touch       = onFaseTouch
  retangulo.fase        = numero_fase
  retangulo:addEventListener( "touch", retangulo )
  retangulo:setFillColor( 0.5 )
  sceneGroup:insert( retangulo )

  local texto_numero_fase                   = display.newText( numero_fase, 0, 0, native.systemFontBold, 24 )
  texto_numero_fase.x, texto_numero_fase.y  = retangulo.x, retangulo.y
  texto_numero_fase:setFillColor( 255 )
  sceneGroup:insert( texto_numero_fase )
end

-- Config body
local function config_body( sceneGroup )
  config_display_fases( sceneGroup )
end


function scene:create( event )
  local sceneGroup = self.view

  config_global( sceneGroup )

  config_header( sceneGroup )

  config_body( sceneGroup )
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