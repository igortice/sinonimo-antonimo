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
  local texto_head            = display.newText( "Créditos", 0, 0, "TrashHand", 40 )
  texto_head.x, texto_head.y  = centerX, 40
  texto_head:setTextColor( 0.3683, 0.3683, 0.3683 )
  sceneGroupCreate:insert( texto_head )

  return
end


---------------------------------------------------------------------------------
-- Body
---------------------------------------------------------------------------------

-- Config equipe
---------------------------------------------------------------------------------
local function config_equipe( )
  local group   = display.newGroup()
  local default_texto = {
     text     = '',
     x        = centerX,
     y        = 115,
     width    = _W - 50,
     fontSize = 20,
     align    = "center",
     font     = "TrashHand"
  }
  local c         = {}

  c[1]            = display.newText(default_texto)
  c[1].text       = "Desenvolvedor\nIgor Rocha"

  c[2]            = display.newText(default_texto)
  c[2].text       = "Designer\nMilena Miranda"


  c[3]            = display.newText(default_texto)
  c[3].text       = "Orientador\nEduardo Mendes"

  c[4]            = display.newText(default_texto)
  c[4].text       = "Estágio 1\nFA7"


  for i=1, #c do
    if (i > 1) then
      c[i].y          = c[i-1].y + 80
    end
    timer.performWithDelay( 1000 * i, function( ) animar_pulsate(c[i], 2.0, 1.2 ); end )
    c[i]:setTextColor( 0.3683, 0.3683, 0.3683 )
    group:insert( c[i] )
  end

  sceneGroupCreate:insert( group )

  return
end

-- Config body
---------------------------------------------------------------------------------
local function config_body( )

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

    config_equipe( )
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