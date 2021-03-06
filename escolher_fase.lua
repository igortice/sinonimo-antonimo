---------------------------------------------------------------------------------
--
-- escolher_fases.lua
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
local data_questions
local fases_liberadas

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

-- Config data questions
---------------------------------------------------------------------------------
local function config_data_questions( )
  local json_data = data.settings.questions
  local json      = require "json"
  data_questions  = json.decode(json_data)

  return
end

-- Config global
---------------------------------------------------------------------------------
local function config_global( sceneGroup )
  fases_liberadas = data.settings.fases_liberadas

  config_scene_group_create( sceneGroup )

  config_background( )

  config_data_questions( )

  return
end


---------------------------------------------------------------------------------
-- Header
---------------------------------------------------------------------------------

-- Config header
---------------------------------------------------------------------------------
local function config_header( )
  local texto_head            = display.newText( "Fases", 0, 0, "TrashHand", 60 )
  texto_head.x, texto_head.y  = centerX, 40
  texto_head:setTextColor( 0.3683, 0.3683, 0.3683 )
  sceneGroupCreate:insert( texto_head )

  return
end


---------------------------------------------------------------------------------
-- Body
---------------------------------------------------------------------------------

-- Config diplay fases body
---------------------------------------------------------------------------------
local function config_display_fases( )
  local function onFaseTouch( self, event )
    if event.phase == "began" then
      play_pop_sound( )

      local options = {
        effect  = "zoomInOutFade",
        params  = {
          fase              = self.fase,
          etapa             = 1,
          tempo             = "00:00",
          questions         = data_questions[self.fase],
          quantidade_erros  = 0
        }
      }
      composer.gotoScene( "etapa", options )
    end

    return
  end

  local tamanho_rec = _W * 0.20
  local init_rect_x = {10, 100, 188}
  local x, y        = 0, - 17
  for numero_fase=1,12 do
    if numero_fase % 3 ~= 0 then
      x = numero_fase % 3
      if (numero_fase % 3  == 1) then
        y = y + 80
      end
    else
      x = 3
    end

    if fases_liberadas < numero_fase then
      local disk_cade                     = display.newImage("assets/images/c_cade.png")
      disk_cade.x, disk_cade.y            = tamanho_rec + init_rect_x[x], tamanho_rec + y
      disk_cade.touch                     = onFaseTouch
      disk_cade.fase                      = numero_fase
      disk_cade.xScale, disk_cade.yScale  = 0.5, 0.5
      sceneGroupCreate:insert( disk_cade )
    else


      local disk_yellow = display.newImage("assets/images/c_yellow.png")
      disk_yellow.x, disk_yellow.y            = tamanho_rec + init_rect_x[x], tamanho_rec + y
      disk_yellow.touch                       = onFaseTouch
      disk_yellow.fase                        = numero_fase
      disk_yellow.xScale, disk_yellow.yScale  = 0.5, 0.5
      sceneGroupCreate:insert( disk_yellow )
      local texto_numero_fase                   = display.newText( numero_fase, 0, 0, "TrashHand", 30 )
      texto_numero_fase.x, texto_numero_fase.y  = disk_yellow.x, disk_yellow.y
      sceneGroupCreate:insert( texto_numero_fase )
      disk_yellow:addEventListener( "touch", disk_yellow )
    end
  end

  return
end

-- Config body
---------------------------------------------------------------------------------
local function config_body( )
  config_display_fases( )

  return
end

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
  elseif ( phase == "did" ) then
    -- Called when the scene is now on screen.
    -- Insert code here to make the scene come alive.
    -- Example: start timers, begin animation, play audio, etc.
    composer.removeScene( "tela_inicial" )

    composer.removeScene( "game_over" )

    composer.removeScene( "fase" )
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