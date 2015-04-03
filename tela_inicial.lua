---------------------------------------------------------------------------------
--
-- tela_inicial.lua
--
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Config Global
---------------------------------------------------------------------------------

-- Require composer
---------------------------------------------------------------------------------
local composer  = require "composer"
local scene     = composer.newScene()

-- Config background
---------------------------------------------------------------------------------
local function config_background( sceneGroup )
  local background  = display.newImage( background_sheet_sprite , background_sheet:getFrameIndex("bg_blue1"))
  background.x      = centerX
  background.y      = centerY

  sceneGroup:insert( background )

  return
end

-- Config global
---------------------------------------------------------------------------------
local function config_global( sceneGroup )
  config_background( sceneGroup )

  return
end


---------------------------------------------------------------------------------
-- Header
---------------------------------------------------------------------------------

-- Config header
---------------------------------------------------------------------------------
local function config_header( sceneGroup )
  local textField = display.newText({
     text     = "Sinônimo \nx \nAntônimo",
     x        = centerX,
     y        = 120,
     width    = 140,
     fontSize = 30,
     align    = "center",
     font     = native.systemFontBold
  })
  sceneGroup:insert( textField )

  return
end


---------------------------------------------------------------------------------
-- Body
---------------------------------------------------------------------------------

-- Config play
---------------------------------------------------------------------------------
local function config_play( sceneGroup )
  local function onIconTouch( self, event )
    if event.phase == "began" then
      audio.play( popSound )

      composer.gotoScene( "escolher_fases", { effect = "zoomInOutFade" } )
    end

    return
  end

  local disk_yellow                       = display.newImage("images/puck_yellow.png")
  disk_yellow.x, disk_yellow.y            = centerX, centerY + 50
  disk_yellow.touch                       = onIconTouch
  disk_yellow.alpha                       = 0.9
  disk_yellow.width, disk_yellow.height   = 80, 80
  disk_yellow:addEventListener( "touch", disk_yellow )
  sceneGroup:insert( disk_yellow )

  local texto_iniciar = display.newText( "Jogar", 0, 0, native.systemFontBold, 22 )
  texto_iniciar:setFillColor( 255 )
  texto_iniciar.x, texto_iniciar.y = centerX, disk_yellow.y
  sceneGroup:insert( texto_iniciar )

  return
end

-- Config body
---------------------------------------------------------------------------------
local function config_body( sceneGroup )
  config_play( sceneGroup )

  return
end


---------------------------------------------------------------------------------
-- Footer
---------------------------------------------------------------------------------

-- Config footer
---------------------------------------------------------------------------------
local function config_footer( sceneGroup )
  local texto_autor = display.newText( "por Igor Rocha", 0, 0, native.systemFontBold, 12 )
  texto_autor:setFillColor( 255 )
  texto_autor.x, texto_autor.y = centerX, _H - 20
  sceneGroup:insert( texto_autor )

  return
end


---------------------------------------------------------------------------------
-- "scene:create()"
---------------------------------------------------------------------------------
function scene:create( event )
  local sceneGroup = self.view

  config_global( sceneGroup )

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