---------------------------------------------------------------------------------
--
-- etapa.lua
--
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Config Global
---------------------------------------------------------------------------------

-- Require composer
---------------------------------------------------------------------------------
local composer  = require "composer"
local scene     = composer.newScene()

-- Config variaveis
---------------------------------------------------------------------------------
local params

-- Config background
---------------------------------------------------------------------------------
local function config_background( sceneGroup )
  local background  = display.newImage( background_sheet_sprite , background_sheet:getFrameIndex("bg_blue3"))
  background.x      = centerX
  background.y      = centerY

  sceneGroup:insert( background )

  return
end

-- Config params etapa fase
---------------------------------------------------------------------------------
local function config_params_etapa_fase( event )
  params = event.params

  return
end

-- Config global
---------------------------------------------------------------------------------
local function config_global( sceneGroup, event )
  config_background( sceneGroup )

  config_params_etapa_fase( event )

  return
end


---------------------------------------------------------------------------------
-- Header
---------------------------------------------------------------------------------

-- Config header
---------------------------------------------------------------------------------
local function config_header( sceneGroup )
  local textField = display.newText({
     text     = "Etapa",
     x        = centerX,
     y        = 120,
     width    = _W,
     fontSize = 50,
     align    = "center",
     font     = native.systemFontBold
  })
  sceneGroup:insert( textField )

  return
end


---------------------------------------------------------------------------------
-- Body
---------------------------------------------------------------------------------

-- Config etapa
---------------------------------------------------------------------------------
local function config_etapa( sceneGroup )
  local disk_yellow                       = display.newImage("images/puck_yellow.png")
  disk_yellow.x, disk_yellow.y            = centerX, centerY
  disk_yellow.alpha                       = 0.9
  disk_yellow:addEventListener( "touch", disk_yellow )

  local etapa = params.etapa
  local texto_iniciar = display.newText( etapa, 0, 0, native.systemFontBold, 40 )
  texto_iniciar.x, texto_iniciar.y = centerX, disk_yellow.y
  transition.to(texto_iniciar, { time = 800, delay = 800, xScale = 2.0, yScale = 2.0, transition = easing.inOutSine })

  local group = display.newGroup()
  group:insert( disk_yellow )
  group:insert( texto_iniciar )
  sceneGroup:insert( group )

  return
end

local function init_etapa_fase( event )
  local options = {
    effect    = "flip",
    delay     = 800,
    params    = params
  }
  composer.gotoScene( "fase", options )

  return
end

-- Config body
---------------------------------------------------------------------------------
local function config_body( sceneGroup )
  config_etapa( sceneGroup )

  return
end


---------------------------------------------------------------------------------
-- Footer
---------------------------------------------------------------------------------

-- Config footer
---------------------------------------------------------------------------------
local function config_footer( sceneGroup )

  return
end


---------------------------------------------------------------------------------
-- "scene:create()"
---------------------------------------------------------------------------------
function scene:create( event )
  local sceneGroup = self.view

  config_global( sceneGroup, event )

  config_header( sceneGroup )

  config_body( sceneGroup )

  config_footer( sceneGroup )

  return
end


---------------------------------------------------------------------------------
-- "scene:show()"
---------------------------------------------------------------------------------
function scene:show( event )
  local sceneGroup  = self.view
  local phase       = event.phase

  if ( phase == "will" ) then
    -- Called when the scene is still off screen (but is about to come on screen).
  elseif ( phase == "did" ) then
    -- Called when the scene is now on screen.
    -- Insert code here to make the scene come alive.
    -- Example: start timers, begin animation, play audio, etc.
    composer.removeScene( "escolher_fase" )
    composer.removeScene( "fase" )

    timer.performWithDelay( 1000, init_etapa_fase, event )
  end

  return
end


---------------------------------------------------------------------------------
-- "scene:hide()"
---------------------------------------------------------------------------------
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

  return
end


---------------------------------------------------------------------------------
-- "scene:destroy()"
---------------------------------------------------------------------------------
function scene:destroy( event )
  local sceneGroup = self.view
  -- Called prior to the removal of scene's view ("sceneGroup").
  -- Insert code here to clean up the scene.
  -- Example: remove display objects, save state, etc.

  return
end


---------------------------------------------------------------------------------
-- Listener setup
---------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene