---------------------------------------------------------------------------------
--
-- configuracoes.lua
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
local sceneGroupCreate

-- Config scene group create
---------------------------------------------------------------------------------
local function config_scene_group_create( sceneGroup)
  sceneGroupCreate  = sceneGroup

  return
end

-- Config background
---------------------------------------------------------------------------------
local function config_background( )
  local background  = display.newImage( "assets/images/bg2.jpg" )
  background.x      = centerX
  background.y      = centerY

  sceneGroupCreate:insert( background )

  return
end

-- Config global
---------------------------------------------------------------------------------
local function config_global( sceneGroup )
  config_scene_group_create( sceneGroup )

  config_background( )

  return
end


---------------------------------------------------------------------------------
-- Header
---------------------------------------------------------------------------------

-- Config header
---------------------------------------------------------------------------------
local function config_header( )
  local texto_head            = display.newText( "Configurações", 0, 0, "TrashHand", 40 )
  texto_head.x, texto_head.y  = centerX, 40
  texto_head:setTextColor( 0.3683, 0.3683, 0.3683 )
  sceneGroupCreate:insert( texto_head )

  return
end


---------------------------------------------------------------------------------
-- Body
---------------------------------------------------------------------------------

-- Config som
---------------------------------------------------------------------------------
local function config_som( )
  local abilitar_som_status = display.newText( "", 0, 0, "TrashHand", 24 )

  local function onIconTouch( self, event )
    if event.phase == "began" then
      play_pop_sound( )

      data.settings.soundOn = not data.settings.soundOn
      local loadsave = require( "loadsave" )
      loadsave.saveTable( data.settings, "settings.json" )

      if (data.settings.soundOn) then
        abilitar_som_status.text = "Sim"
      else
        abilitar_som_status.text = "Não"
      end

    end

    return
  end

  local texto_abilitar_som = display.newText( "som abilitado?", 0, 0, "TrashHand", 24 )
  texto_abilitar_som:setTextColor( 0.3683, 0.3683, 0.3683 )
  texto_abilitar_som.x, texto_abilitar_som.y  = centerX, 100

  local btn_abilitar_som                  = display.newImage("assets/images/c_verde.png")
  btn_abilitar_som.x, btn_abilitar_som.y  = texto_abilitar_som.x, texto_abilitar_som.y + 50
  btn_abilitar_som.touch                  = onIconTouch
  btn_abilitar_som:addEventListener( "touch", btn_abilitar_som )

  
  if (data.settings.soundOn) then
    abilitar_som_status.text = "Sim"
  else
    abilitar_som_status.text = "Não"
  end
  abilitar_som_status:setTextColor( 0.3683, 0.3683, 0.3683 )
  abilitar_som_status.x, abilitar_som_status.y  = btn_abilitar_som.x, btn_abilitar_som.y

  local group = display.newGroup()
  group:insert( texto_abilitar_som )
  group:insert( btn_abilitar_som )
  group:insert( abilitar_som_status )
  sceneGroupCreate:insert( group )

  return
end


-- Config body
---------------------------------------------------------------------------------
local function config_body( )
  config_som( )

  return
end


---------------------------------------------------------------------------------
-- Footer
---------------------------------------------------------------------------------

-- Config footer
---------------------------------------------------------------------------------
local function config_footer( )
  local function onIconTouch( self, event )
    if event.phase == "began" then
      play_pop_sound( )

      composer.gotoScene( "tela_inicial", { effect = "zoomInOutFade", time = 500 } )
    elseif event.phase == "ended" or event.phase == "cancelled" then
      self.alpha = 0.25
    end

    return
  end


  local texto_retornar = display.newText( "retornar", 0, 0, "TrashHand", 24 )
  texto_retornar:setTextColor( 0.3683, 0.3683, 0.3683 )
  texto_retornar.x, texto_retornar.y  = centerX, _H - 50
  texto_retornar.touch                = onIconTouch
  texto_retornar:addEventListener( "touch", texto_retornar )

  sceneGroupCreate:insert( texto_retornar )

  return
end


---------------------------------------------------------------------------------
-- "scene:create()"
---------------------------------------------------------------------------------
function scene:create( event )
  config_global( self.view )

  config_header( )

  config_body( )

  config_footer( )
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
    composer.removeScene( "tela_inicial" )
  end
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
end


---------------------------------------------------------------------------------
-- "scene:destroy()"
---------------------------------------------------------------------------------
function scene:destroy( event )
  local sceneGroup = self.view

  -- Called prior to the removal of scene's view ("sceneGroup").
  -- Insert code here to clean up the scene.
  -- Example: remove display objects, save state, etc.
end


---------------------------------------------------------------------------------
-- Listener setup
---------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene