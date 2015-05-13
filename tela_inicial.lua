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
  local background  = display.newImage( "assets/images/bg1.jpg" )
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
  -- local textField1 = display.newEmbossedText({
  --    text     = "o que é",
  --    x        = centerX - 65,
  --    y        = 50,
  --    width    = 200,
  --    fontSize = 55,
  --    align    = "center",
  --    font     = "TrashHand"
  -- })
  -- textField1:setTextColor( 0, 242, 232 )

  return
end


---------------------------------------------------------------------------------
-- Body
---------------------------------------------------------------------------------

-- Config logo
---------------------------------------------------------------------------------
local function config_logo(  )
  local function animar_pulsate( objeto )
    local function1
    local trans

    local function function1(e)
      trans = transition.to(objeto, { time = 500, xScale = 1, yScale = 1, transition = easing.linear})
    end

    transition.to(objeto, { time = 500, delay = 500, xScale = 1.5, yScale = 1.5, transition = easing.linear, onComplete=function1})

    return
  end

  local oq1 = display.newImage( "assets/images/oq1.png" )
  oq1.x, oq1.y          = centerX - 65, 50
  oq1.width, oq1.height = 140, 60

  local interrogacao = display.newImage( "assets/images/int.png" )
  interrogacao.x, interrogacao.y = centerX, centerY - 30

  local oq2 = display.newImage( "assets/images/oq2.png" )
  oq2.x, oq2.y          = centerX + 70, centerY + 45
  oq2.width, oq2.height = 110, 60


  oq1.xScale, oq1.yScale = 0.01, 0.01
  animar_pulsate(oq1)

  oq2.xScale, oq2.yScale = 0.01, 0.01
  timer.performWithDelay( 800, function( ) animar_pulsate(oq2); end )

  local group = display.newGroup()
  group:insert( oq1 )
  group:insert( interrogacao )
  group:insert( oq2 )
  sceneGroupCreate:insert( group )

  return
end

-- Config play
---------------------------------------------------------------------------------
local function config_play( )
  local function onIconTouch( self, event )
    if event.phase == "began" then
      play_pop_sound( )

      composer.gotoScene( "escolher_fase", { effect = "zoomInOutFade" } )
    end

    return
  end

  local play     = display.newImage("assets/images/play.png")
  play.x, play.y = _W / 4.3, _H - 70
  play.touch     = onIconTouch
  play:addEventListener( "touch", play )
  sceneGroupCreate:insert( play )

  return
end



-- Config config
---------------------------------------------------------------------------------
local function config_config( )
  local function onIconTouch( self, event )
    if event.phase == "began" then
      play_pop_sound( )

      composer.gotoScene( "configuracoes", { effect = "zoomInOutFade" } )
    end

    return
  end

  local config        = display.newImage("assets/images/config.png")
  config.x, config.y  = _W / 1.3, _H - 70
  config.touch        = onIconTouch
  config:addEventListener( "touch", config )
  sceneGroupCreate:insert( config )

  return
end

local function config_menu( )
  config_play( )

  config_config( )

  return
end

-- Config body
---------------------------------------------------------------------------------
local function config_body( )
  config_menu( )

  return
end


---------------------------------------------------------------------------------
-- Footer
---------------------------------------------------------------------------------

-- Config footer
---------------------------------------------------------------------------------
local function config_footer( )
  local texto_autor             = display.newText( "por Igor Rocha", 0, 0, native.systemFontBold, 12 )
  texto_autor.x, texto_autor.y  = centerX, _H - 20
  sceneGroupCreate:insert( texto_autor )

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

    config_logo( )
  elseif ( phase == "did" ) then
    -- Called when the scene is now on screen.
    -- Insert code here to make the scene come alive.
    -- Example: start timers, begin animation, play audio, etc.
    composer.removeScene( "escolher_fase" )

    composer.removeScene( "configuracoes" )
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