---------------------------------------------------------------------------------
--
-- fase.lua
--
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Config Global
---------------------------------------------------------------------------------

-- Require composer
---------------------------------------------------------------------------------
local composer  = require "composer"
local scene     = composer.newScene()

-- Require glyphicons
---------------------------------------------------------------------------------
local glyphicons        = require("glyphicons")
local glyphicons_sprite = graphics.newImageSheet("glyphicons/glyphicons_sprites2.png", glyphicons:getSheet())

-- Require physics
---------------------------------------------------------------------------------
local physics   = require("physics")
local gameUI    = require("gameUI")

-- Init physics
---------------------------------------------------------------------------------
physics.start()
physics.setGravity( 0, 0 )
system.activate( "multitouch" )
-- physics.setDrawMode( "hybrid" )

-- Config variaveis
---------------------------------------------------------------------------------
local sceneGroupCreate, params
local tempo_to_seconds, displayTime

local quantidade_lifes  = 3
local lifes_imagens     = {}

local retangulo, pergunta, resposta, resposta_array
local resposta_usuario_array = {}

local config_gerar_letras_etapa

-- Config scene group create
---------------------------------------------------------------------------------
local function config_scene_group_create( sceneGroup )
  sceneGroupCreate  = sceneGroup

  return
end

-- Config params fase
---------------------------------------------------------------------------------
local function config_params_etapa( event )
  params            = event.params

  return
end

-- Config background
---------------------------------------------------------------------------------
local function config_background( )
  local background  = display.newImage( "assets/images/bg2.jpg" )
  background.x      = display.contentCenterX
  background.y      = display.contentCenterY
  sceneGroupCreate:insert( background )

  return
end

-- Config tempo to seconds
---------------------------------------------------------------------------------
local function config_tempo_to_seconds( )
  local tempo       = split(params.tempo, ":")
  tempo_to_seconds  = ( tonumber( tempo[1] ) * 60) + (tonumber( tempo[2] ) )

  return
end

-- Config global
---------------------------------------------------------------------------------
local function config_global( sceneGroup, event )
  config_scene_group_create( sceneGroup )

  config_params_etapa( event )

  config_background( )

  config_tempo_to_seconds( )

  return
end


---------------------------------------------------------------------------------
-- Header
---------------------------------------------------------------------------------

-- Config count timer
---------------------------------------------------------------------------------
local function config_count_timer( )
  local disk_verde       = display.newImage("assets/images/c_verde.png")
  disk_verde.width, disk_verde.height = 45, 45
  disk_verde.x, disk_verde.y = 60, 25
  sceneGroupCreate:insert( disk_verde )

  displayTime = display.newText({
     text     = params.tempo,
     x        = disk_verde.x,
     y        = disk_verde.y,
     fontSize = 13,
     font     = "TrashHand"
  })
  displayTime:setTextColor( 0.3683, 0.3683, 0.3683 )
  sceneGroupCreate:insert( displayTime )

  local levelTime = tempo_to_seconds
  local modf      = math.modf
  local function checkTime(event)
    levelTime           = levelTime + 1
    local start_seconds = levelTime

    local start_minutes = modf(start_seconds/60)
    local seconds       = start_seconds - start_minutes*60

    local start_hours = modf(start_minutes/60)
    local minutes     = start_minutes - start_hours*60

    local start_days  = modf(start_hours/24)
    local hours       = start_hours - start_days*24

    local min = minutes < 10 and ("0" .. minutes) or minutes
    local sec = seconds < 10 and ("0" .. seconds) or seconds

    displayTime.text = min .. ":" .. sec
  end
  timer.performWithDelay( 1000, checkTime, levelTime )

  return
end

--  Config lifes
---------------------------------------------------------------------------------
local function config_lifes( )

  local disk_verde       = display.newImage("assets/images/c_life.png")
  disk_verde.width, disk_verde.height = 45, 45
  disk_verde.x, disk_verde.y = _W- 60, 25
  sceneGroupCreate:insert( disk_verde )

  local textField = display.newText({
     text     = quantidade_lifes - params.quantidade_erros,
     x        = disk_verde.x + 1,
     y        = disk_verde.y,
     fontSize = 13,
     font     = "TrashHand"
  })
  textField:setTextColor( 0.3683, 0.3683, 0.3683 )
  sceneGroupCreate:insert( textField )

  -- for i=1, quantidade_lifes do
  --   if not lifes_imagens[i] then
  --     lifes_imagens[i] = display.newImage(glyphicons_sprite, glyphicons:getFrameIndex("heart"))
  --   end

  --   if params.quantidade_erros >= i then
  --     lifes_imagens[i]:removeSelf()

  --     lifes_imagens[i] = display.newImage(glyphicons_sprite, glyphicons:getFrameIndex("heart_empty"))

  --     transition.to(lifes_imagens[i], { time = 800, xScale = 0.5, yScale = 0.5, transition = easing.outElastic  })
  --   end

  --   lifes_imagens[i].width, lifes_imagens[i].height = 15, 15
  --   lifes_imagens[i].x, lifes_imagens[i].y          = _W - 115 + (i*20), 20
  --   sceneGroupCreate:insert( lifes_imagens[i] )
  -- end

  return
end

-- Config remover life
---------------------------------------------------------------------------------
local function config_remover_life( )
  if params.quantidade_erros <= quantidade_lifes then
    params.quantidade_erros = params.quantidade_erros + 1

    config_lifes( )

    if params.quantidade_erros == quantidade_lifes then
      composer.gotoScene( "game_over", { effect = "zoomInOutFade" } )
    end
  end

  return
end

-- Config name fase
---------------------------------------------------------------------------------
local function config_nome_fase( )

  local disk_verde       = display.newImage("assets/images/c_verde.png")
  disk_verde.width, disk_verde.height = 45, 45
  disk_verde.x, disk_verde.y = centerX, 25
  sceneGroupCreate:insert( disk_verde )

  local textField = display.newText({
     text     = params.etapa .. " - " .. #params.questions,
     x        = disk_verde.x,
     y        = disk_verde.y,
     fontSize = 13,
     font     = "TrashHand"
  })
  textField:setTextColor( 0.3683, 0.3683, 0.3683 )
  sceneGroupCreate:insert( textField )

  return
end

-- Config header
---------------------------------------------------------------------------------
local function config_header( )
  config_nome_fase( )

  config_lifes( )

  return
end


---------------------------------------------------------------------------------
-- Body
---------------------------------------------------------------------------------

-- Get pergunta fase
---------------------------------------------------------------------------------
local function get_pergunta_fase( )

  return params.questions[params.etapa].palavra:lower( )
end

-- Get proxima etapa
---------------------------------------------------------------------------------
function get_proxima_etapa( )
  params.tempo  = displayTime.text
  local options = {
    effect  = "fromLeft",
    params  = params
  }
  composer.gotoScene( "etapa", options )

  return
end

-- Get proxima fase
---------------------------------------------------------------------------------
function get_proxima_fase( )
  data.settings.fases_liberadas   = params.fase + 1
  local loadsave = require( "loadsave" )
  loadsave.saveTable( data.settings, "settings.json" )
  local options = {
    effect  = "flipFadeOutIn"
  }
  composer.gotoScene( "escolher_fase", options )

  return
end

-- Set respostas
---------------------------------------------------------------------------------
local function set_resposta( letra )
  resposta              = params.questions[params.etapa].resposta
  resposta_array        = to_array( resposta )

  local result_resposta = ""

  local indexs_letra    = allIndexOf(resposta_array, letra)
  for i=1, #indexs_letra do
    if resposta_usuario_array[indexs_letra[i]] == nil then
      resposta_usuario_array[indexs_letra[i]] = letra

      break
    end
  end

  for i=1, #resposta do
    local palavra = '_'
    if resposta_usuario_array and resposta_usuario_array[i] ~= nil then
      palavra = resposta_usuario_array[i]
    end
    result_resposta = result_resposta .. palavra .. ' '
  end

  return result_resposta:upper( )
end

-- Set questions
---------------------------------------------------------------------------------
local function set_question( )
  pergunta.text = get_pergunta_fase( ) .. "\n" .. set_resposta( )

  return
end


-- Config questions
---------------------------------------------------------------------------------
local function config_questions( )
  pergunta = display.newText({
     text     = '',
     x        = centerX,
     y        = 110,
     width    = _W - 100,
     fontSize = 22,
     align    = "center",
     font     = "TrashHand"
  })
  pergunta:setTextColor( 0.3683, 0.3683, 0.3683 )

  set_question( )

  retangulo = display.newRect( centerX, pergunta.y + 3, _W , 120 )
  -- retangulo.strokeWidth = 3
  retangulo.alpha       = 0.3
  -- retangulo:setFillColor( 0 )
  -- retangulo:setStrokeColor( 1, 1, 1 )

  local group = display.newGroup()
  group:insert( retangulo )
  group:insert( pergunta )
  sceneGroupCreate:insert( group )

  return
end

-- Check letra
---------------------------------------------------------------------------------
local function check_letra( letra )
  local function1, function2

  function function1( )
    transition.to( retangulo, { time=100, onComplete=function2 } )

    return
  end

  function function2( )
    retangulo:setFillColor( 1 )

    transition.to( retangulo, { time=100, alpha=0.3 } )

    return
  end

  if #allIndexOf( resposta_array, letra) == 0 then
    config_remover_life( )

    play_buzz_sound( )

    retangulo:setFillColor(255, 0, 0)
  else
    retangulo:setFillColor(128, 255, 0)

    play_pop_sound( )
  end

  transition.to( retangulo, { time=100, alpha=0.3, onComplete = function1 } )

  pergunta.text = get_pergunta_fase( ) .. "\n" .. set_resposta( letra )
  local res_usu = ""
  for k,v in pairs(resposta_usuario_array) do
    res_usu = res_usu .. v
  end

  if res_usu == resposta then
    params.etapa  = params.etapa + 1

    if params.etapa > #params.questions then
      get_proxima_fase( )

      return
    end

    get_proxima_etapa( )
  end

  return
end

--Config letras body
---------------------------------------------------------------------------------
local function config_letras_body( )
  local alfabeto              = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z" }
  local all_objects_alfabeto  = {}
  local regiao_letras         = { xi="70", xf="260", yi="200", yf="420" }

  -- Config drag letra
  ---------------------------------------------------------------------------------
  local function config_drag_letra()
    for i = 1, #all_objects_alfabeto do
      local object_alfabeto = all_objects_alfabeto[i]
      if object_alfabeto and object_alfabeto.x then
        if object_alfabeto.y < 154 then
          check_letra( object_alfabeto.letra )

          object_alfabeto:removeSelf()

          table.remove( all_objects_alfabeto, i )
        end

        if object_alfabeto.x < 10 or object_alfabeto.x > _W - 10 or object_alfabeto.y < -1 or object_alfabeto.y > _H - 10 then
          play_pop_sound( )

          -- object_alfabeto:removeSelf()
          object_alfabeto.isAwake = false
          object_alfabeto.x       = math.random( regiao_letras.xi , regiao_letras.xf)
          object_alfabeto.y       = math.random( regiao_letras.yi , regiao_letras.yf)
          -- table.remove( all_objects_alfabeto, i )
        end
      end
    end

    return
  end

  -- Config drag body
  ---------------------------------------------------------------------------------
  local function config_drag_body( event )
    return gameUI.dragBody( event )
  end

  -- Config gerar letras etapas
  ---------------------------------------------------------------------------------
  function config_gerar_letras_etapa()
    local quantidade_letras_body  = #resposta_array * 3
    local letras_body             = table.copy(resposta_array)
    while #letras_body ~= quantidade_letras_body do
        letras_body[#letras_body+1] = alfabeto[ math.random( 1, #alfabeto ) ]
    end

    letras_body = shuffleTable( letras_body )

    for i=1, #letras_body do
      play_pop_sound( )

      local letra                                       = letras_body[i]
      local path_letra                                  = "assets/images/alfabeto/" .. letra .. ".png"
      all_objects_alfabeto[#all_objects_alfabeto + 1]   = display.newImage( path_letra )

      local object_alfabeto                           = all_objects_alfabeto[#all_objects_alfabeto]
      object_alfabeto.x                               = math.random( regiao_letras.xi , regiao_letras.xf)
      object_alfabeto.y                               = math.random( regiao_letras.yi , regiao_letras.yf)
      object_alfabeto.width, object_alfabeto.height   = 20, 20
      object_alfabeto.rotation                        = math.random( 1, 360 )
      object_alfabeto.xScale, object_alfabeto.yScale  = 0.8, 0.8
      object_alfabeto.letra                           = letra
      transition.to(object_alfabeto, { time = 800, xScale = 2.0, yScale = 2.0, transition = easing.outElastic })

      physics.addBody( object_alfabeto, { density=0.6, friction=1 } )
      object_alfabeto.linearDamping  = 0.4
      object_alfabeto.angularDamping = 1.6
      object_alfabeto:addEventListener( "touch", config_drag_body )
      sceneGroupCreate:insert( object_alfabeto )
    end

    return
  end

  Runtime:addEventListener( "enterFrame", config_drag_letra )

  return
end

-- Config body
---------------------------------------------------------------------------------
local function config_body( sceneGroup, event )
  config_questions( )

  config_letras_body( )

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

      composer.gotoScene( "escolher_fase", { effect = "zoomInOutFade", time = 500 } )
    elseif event.phase == "ended" or event.phase == "cancelled" then
      self.alpha = 0.25
    end

    return
  end


  local texto_retornar = display.newText( "retornar", 0, 0, "TrashHand", 24 )
  texto_retornar:setTextColor( 0.3683, 0.3683, 0.3683 )
  texto_retornar.x, texto_retornar.y  = centerX, _H - 30
  texto_retornar.touch                = onIconTouch
  texto_retornar:addEventListener( "touch", texto_retornar )

  sceneGroupCreate:insert( texto_retornar )

  return
end


---------------------------------------------------------------------------------
-- "scene:create()"
---------------------------------------------------------------------------------
function scene:create( event )
  config_global( self.view, event )

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

    config_count_timer( )
  elseif ( phase == "did" ) then
    -- Called when the scene is now on screen.
    -- Insert code here to make the scene come alive.
    -- Example: start timers, begin animation, play audio, etc.

    config_gerar_letras_etapa( )

    composer.removeScene( "etapa" )
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