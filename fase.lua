---------------------------------------------------------------------------------
--
-- fase.lua
--
---------------------------------------------------------------------------------

local composer  = require "composer"
local scene     = composer.newScene()

local physics   = require("physics")
local gameUI    = require("gameUI")
-- physics.setDrawMode( "hybrid" )

physics.start()
physics.setGravity( 0, 0 ) -- no gravity in any direction

system.activate( "multitouch" )


local background_sheet        = require("bg_sheets")
local background_sheet_sprite = graphics.newImageSheet( "images/bg_spritesheet.png", background_sheet:getSheet() )

local glyphicons        = require("glyphicons")
local glyphicons_sprite = graphics.newImageSheet("glyphicons/glyphicons_sprites2.png", glyphicons:getSheet())

---------------------------------------------------------------------------------
-- Config Global
---------------------------------------------------------------------------------

-- Config background
---------------------------------------------------------------------------------
local background

local function config_background( sceneGroup )
  background        = display.newImage( background_sheet_sprite , background_sheet:getFrameIndex("bg_blue3"))
  background.x      = display.contentCenterX
  background.y      = display.contentCenterY

  sceneGroup:insert( background )
end

-- Config quantidade de questions
---------------------------------------------------------------------------------
local questions, quantidade_questions, etapa, tempo_inicial, tempo_inicial_seconds, quantidade_erros

local function config_params_etapa( sceneGroup, event )
  questions             = event.params.questions
  quantidade_questions  = #questions
  etapa                 = event.params.etapa
  tempo_inicial         = event.params.tempo
  quantidade_erros      = event.params.quantidade_erros
  local tempo = split(tempo_inicial, ':')
  tempo_inicial_seconds = (tonumber( tempo[1] ) * 60) + (tonumber( tempo[2] ))
end

-- Config global
local function config_global( sceneGroup, event )
  config_background( sceneGroup )

  config_params_etapa( sceneGroup, event )
end


---------------------------------------------------------------------------------
-- Header
---------------------------------------------------------------------------------

-- Config count timer
---------------------------------------------------------------------------------
local function config_count_timer( sceneGroup )
  displayTime = display.newText({
     text     = tempo_inicial,
     x        = centerX,
     y        = 20,
     width    = _W - 100,
     fontSize = 20,
     align    = "left"
  })
  sceneGroup:insert( displayTime )

  local levelTime = tempo_inicial_seconds
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
end

--  Config lifes
---------------------------------------------------------------------------------
local quantidade_lifes  = 3
local lifes_imagens     = {}

local function config_lifes( sceneGroup )
  for i=1,quantidade_lifes do
    if not lifes_imagens[i] then
      lifes_imagens[i]      = display.newImage(glyphicons_sprite, glyphicons:getFrameIndex("heart"))
    end

    if quantidade_erros >= i then
      lifes_imagens[i]:removeSelf()
      lifes_imagens[i]      = display.newImage(glyphicons_sprite, glyphicons:getFrameIndex("heart_empty"))
      transition.to(lifes_imagens[i], { time = 800, xScale = 1.5, yScale = 1.5, transition = easing.outElastic  }) -- "pop" animation
    end

    lifes_imagens[i].width, lifes_imagens[i].height = 15, 15
    lifes_imagens[i].x, lifes_imagens[i].y  = _W - 115 + (i*20), 20

    sceneGroup:insert( lifes_imagens[i] )
  end
end

-- Remover life
---------------------------------------------------------------------------------
local function remover_life( sceneGroup )
    if (quantidade_erros <= quantidade_lifes) then
      quantidade_erros = quantidade_erros + 1
      config_lifes( sceneGroup )

      if (quantidade_erros == quantidade_lifes) then
        composer.gotoScene( "game_over", { effect = "zoomInOutFade", time = 500 } )
      end

      return true
    end

    return false
end

-- Config name fase
---------------------------------------------------------------------------------
local function config_nome_fase( sceneGroup, event )
  local textField = display.newText({
     text     = 'Fase:' .. event.params.fase,
     x        = centerX,
     y        = 20,
     fontSize = 20
  })
  sceneGroup:insert( textField )
end

-- Config header
---------------------------------------------------------------------------------
local function config_header( sceneGroup, event )
  config_nome_fase( sceneGroup, event )

  config_lifes( sceneGroup )
end


---------------------------------------------------------------------------------
-- Body
---------------------------------------------------------------------------------

-- Variaveis
---------------------------------------------------------------------------------
local retangulo, pergunta, resposta, resposta_array, pergunta_fase
local resposta_usuario_array = {}

-- Set respostas
---------------------------------------------------------------------------------
local function set_resposta( event, letra )
  resposta            = event.params.questions[etapa].resposta
  resposta_array      = to_array( resposta )
  result_resposta     = ''
  local indexs_letra  = allIndexOf(resposta_array, letra)
  for i=1,#indexs_letra do
    if (resposta_usuario_array[indexs_letra[i]] == nil) then
      resposta_usuario_array[indexs_letra[i]] = letra
      break
    end
  end

  for i=1,#resposta do
    local palavra = '__'
    if resposta_usuario_array and resposta_usuario_array[i] ~= nil then
      palavra = resposta_usuario_array[i]
    end
    result_resposta = result_resposta .. palavra .. ' '
  end

  return result_resposta
end

-- Check letra
---------------------------------------------------------------------------------
local function check_letra( sceneGroup, event, letra )
  local function1, function2

  function function1(e)
    transition.to(retangulo,{time=100, onComplete=function2})
  end

  function function2(e)
    retangulo:setFillColor( 0 )
    transition.to(retangulo, { time=100,alpha=0.5 })
  end

  if #allIndexOf( resposta_array, letra) == 0 then
    remover_life( sceneGroup )
    retangulo:setFillColor(255, 0, 0)
  else
    retangulo:setFillColor(128, 255, 0)
  end

  audio.play( popSound )
  transition.to(retangulo,{time=100,alpha=0.5, onComplete = function1})
  pergunta.text = pergunta_fase:upper( ) .. "\n" .. set_resposta( event, letra ):upper( )
  if (table.concat(resposta_usuario_array, "") == resposta) then
    proxima_fase( event )
  end
  return true
end

-- Set pergunta
---------------------------------------------------------------------------------
local function set_pergunta( event )
  pergunta_fase = event.params.questions[etapa].palavra

  return pergunta_fase
end

-- Set questions
---------------------------------------------------------------------------------
local function set_question( event )
  pergunta.text = set_pergunta( event ):upper( ) .. "\n" .. set_resposta( event ):upper( )
end
-- Set questions
---------------------------------------------------------------------------------
function proxima_fase( event )

    return true
end

-- Config questions
---------------------------------------------------------------------------------
local function config_questions( sceneGroup, event )
  pergunta = display.newText({
     text     = '',
     x        = centerX,
     y        = 100,
     width    = _W - 100,
     fontSize = 20,
     align    = "center"
  })

  set_question( event )

  retangulo = display.newRect( centerX, pergunta.y, _W - 100, 100 )
  retangulo.strokeWidth = 3
  retangulo.alpha       = 0.5
  retangulo:setFillColor( 0 )
  retangulo:setStrokeColor( 1, 1, 1 )

  sceneGroup:insert( retangulo )
  sceneGroup:insert( pergunta )
end

--Config letras body
---------------------------------------------------------------------------------
local function config_letras_body( sceneGroup, event )
  local alfabeto              = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"}
  local all_objects_alfabeto  = {}
  local regiao_letras         = {xi="70", xf="260", yi="200", yf="450"}

  -- Config drag letra
  ---------------------------------------------------------------------------------
  local function config_drag_letra()
    for i = 1, #all_objects_alfabeto do
      local object_alfabeto = all_objects_alfabeto[i]
      if (object_alfabeto and object_alfabeto.x) then
        if object_alfabeto.y < 154 then
          print( object_alfabeto.letra )
          check_letra( sceneGroup, event, object_alfabeto.letra )
          object_alfabeto:removeSelf()
          table.remove( all_objects_alfabeto, i )

        end
        if object_alfabeto.x < 10 or object_alfabeto.x > _W - 10 or object_alfabeto.y < -1 or object_alfabeto.y > _H - 10 then
          print( 'saiu' )
          audio.play( popSound )
          -- object_alfabeto:removeSelf()
          object_alfabeto.isAwake = false
          object_alfabeto.x = math.random( regiao_letras.xi , regiao_letras.xf)
          object_alfabeto.y = math.random( regiao_letras.yi , regiao_letras.yf)
          -- table.remove( all_objects_alfabeto, i )
        end
      end
    end
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

    for i=1,#letras_body do
      audio.play( popSound )

      local letra = letras_body[i]
      path_letra  = "images/alfabeto/" .. letra .. ".png"
      all_objects_alfabeto[#all_objects_alfabeto + 1] = display.newImage( path_letra )
      local object_alfabeto = all_objects_alfabeto[#all_objects_alfabeto]
      object_alfabeto.x = math.random( regiao_letras.xi , regiao_letras.xf)
      object_alfabeto.y = math.random( regiao_letras.yi , regiao_letras.yf)
      object_alfabeto.width, object_alfabeto.height = 20, 20
      object_alfabeto.rotation = math.random( 1, 360 )
      object_alfabeto.xScale, object_alfabeto.yScale = 0.8, 0.8
      object_alfabeto.letra = letra

      transition.to(object_alfabeto, { time = 800, xScale = 2.0, yScale = 2.0, transition = easing.outElastic })

      physics.addBody( object_alfabeto, { density=0.6, friction=1 } )
      object_alfabeto.linearDamping  = 0.4
      object_alfabeto.angularDamping = 1.6

      object_alfabeto:addEventListener( "touch", config_drag_body )
      sceneGroup:insert( object_alfabeto )
    end
  end

  Runtime:addEventListener( "enterFrame", config_drag_letra ) -- clean up offscreen disks
end

-- Config body
local function config_body( sceneGroup, event )
  config_questions( sceneGroup, event )

  config_letras_body( sceneGroup, event )
end


---------------------------------------------------------------------------------
-- Footer
---------------------------------------------------------------------------------

-- Config footer
local function config_footer( sceneGroup )
end

function scene:create( event )
  local sceneGroup = self.view

  config_global( sceneGroup, event )

  config_header( sceneGroup, event )

  config_body( sceneGroup , event )

  config_footer( sceneGroup )
end

-- "scene:show()"
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
      config_count_timer( sceneGroup )
      config_gerar_letras_etapa()
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
        composer.removeScene( "fase" )
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