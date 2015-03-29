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

local function to_array( str )
  local t = {}
  for i = 1, #str do
      t[i] = str:sub(i, i)
  end

  return t
end
local background
-- Configurar background
local function config_background( sceneGroup )

  background        = display.newImage( background_sheet_sprite , background_sheet:getFrameIndex("bg_blue3"))
  background.x      = display.contentCenterX
  background.y      = display.contentCenterY

  sceneGroup:insert( background )
end

-- Config quantidade de questions
local quantidade_questions
local function config_quantidade_questions( sceneGroup, event )
  quantidade_questions = #event.params.questions
end

-- Config global
local function config_global( sceneGroup, event )
  config_background( sceneGroup )

  config_quantidade_questions( sceneGroup, event )
end


---------------------------------------------------------------------------------
-- Header
---------------------------------------------------------------------------------

-- Config count timer
local function config_count_timer( sceneGroup )
  local displayTime = display.newText({
     text     = "00:00",
     x        = centerX,
     y        = 20,
     width    = _W - 100,
     fontSize = 20,
     align    = "left"
  })
  sceneGroup:insert( displayTime )

  local levelTime = 0
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
local quantidade_lifes = 3
local quantidade_erros = 0
local lifes_imagens = {}
local function config_lifes( sceneGroup )
  for i=1,quantidade_lifes do
    if not lifes_imagens[i] then
      lifes_imagens[i]      = display.newImage(glyphicons_sprite, glyphicons:getFrameIndex("heart"))
    elseif quantidade_erros >= i then
      lifes_imagens[i]:removeSelf()
      lifes_imagens[i]      = display.newImage(glyphicons_sprite, glyphicons:getFrameIndex("heart_empty"))
      transition.to(lifes_imagens[i], { time = 1500, xScale = 1.5, yScale = 1.5, transition = easing.outElastic  }) -- "pop" animation
    end

    lifes_imagens[i].width, lifes_imagens[i].height = 15, 15
    lifes_imagens[i].x, lifes_imagens[i].y  = _W - 115 + (i*20), 20

    sceneGroup:insert( lifes_imagens[i] )
  end
end

-- Remover life
local function remover_life( sceneGroup )
    if (quantidade_erros <= quantidade_lifes) then
      quantidade_erros = quantidade_erros + 1
      config_lifes( sceneGroup )

      return true
    end

    return false
end

local function config_nome_fase( sceneGroup, event )
  local textField = display.newText({
     text     = event.params.level,
     x        = centerX,
     y        = 20,
     fontSize = 20
  })
  sceneGroup:insert( textField )
end

-- Config header
local function config_header( sceneGroup, event )
  config_nome_fase( sceneGroup, event )

  config_lifes( sceneGroup )
end


---------------------------------------------------------------------------------
-- Body
---------------------------------------------------------------------------------

local repostas_ok = 1, pergunta, resposta, resposta_array, pergunta_fase
local resposta_usuario_array = {}

local function set_resposta( event, letra )
  resposta        = event.params.questions[repostas_ok + 1].resposta
  resposta_array  = to_array( resposta )
  result_resposta = ''
  index_letra = table.indexOf(resposta_array, letra)
  if (index_letra ~= nil) then
    resposta_usuario_array[index_letra] = letra
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

local function check_letra( sceneGroup, event, letra )
  if table.indexOf(resposta_array, letra) == nil then
    remover_life( sceneGroup )
  end

  pergunta.text = pergunta_fase:upper( ) .. "\n" .. set_resposta( event, letra ):upper( )

  return true
end

local function set_pergunta( event )
  pergunta_fase = event.params.questions[repostas_ok + 1].palavra

  return pergunta_fase
end

local function set_question( event, num )
  repostas_ok = num

  pergunta.text = set_pergunta( event ):upper( ) .. "\n" .. set_resposta( event ):upper( )
end

-- Config questions
local function config_questions( sceneGroup, event )
  pergunta = display.newText({
     text     = '',
     x        = centerX,
     y        = 100,
     width    = _W - 100,
     fontSize = 20,
     align    = "center"
  })

  set_question( event, repostas_ok )

  local retangulo = display.newRect( centerX, pergunta.y, _W - 100, 100 )
  retangulo.strokeWidth = 3
  retangulo.alpha       = 0.5
  retangulo:setFillColor( 0 )
  retangulo:setStrokeColor( 1, 1, 1 )

  sceneGroup:insert( retangulo )
  sceneGroup:insert( pergunta )
end

--Config dicas
local function config_letras_body( sceneGroup, event )

  local alfabeto = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"}
  -- for i=1,#alfabeto do
  --   alfabeto[i] = "images/alfabeto/" .. alfabeto[i] .. ".png"
  -- end
  local allDisks = {} -- empty table for storing objects

  -- Automatic culling of offscreen objects
  local function config_drag_letra()
    for i = 1, #allDisks do
      local oneDisk = allDisks[i]
      if (oneDisk and oneDisk.x) then
        if oneDisk.y < 154 then
          print( oneDisk.letra )
          check_letra( sceneGroup, event, oneDisk.letra )
          oneDisk:removeSelf()
          table.remove( allDisks, i )

        end
        if oneDisk.x < 10 or oneDisk.x > _W - 10 or oneDisk.y < -1 or oneDisk.y > _H - 10 then
          print( 'saiu' )
          oneDisk:removeSelf()
          table.remove( allDisks, i )
        end
      end
    end
  end

  local function dragBody( event )
    return gameUI.dragBody( event )
  end

  local function spawnDisk( event )
    local phase = event.phase

    if "ended" == phase then
      audio.play( popSound )

      letra = alfabeto[ math.random( 1, #alfabeto ) ]
      path_letra = "images/alfabeto/" .. letra .. ".png"
      allDisks[#allDisks + 1] = display.newImage( path_letra )
      local disk = allDisks[#allDisks]
      disk.x = event.x; disk.y = event.y
      disk.width, disk.height = 30, 30
      disk.rotation = math.random( 1, 360 )
      disk.xScale = 0.8; disk.yScale = 0.8
      disk.letra = letra

      transition.to(disk, { time = 1500, xScale = 2.0, yScale = 2.0, transition = easing.outElastic }) -- "pop" animation

      physics.addBody( disk, { density=0.6, friction=1 } )
      disk.linearDamping  = 0.4
      disk.angularDamping = 0.6

      disk:addEventListener( "touch", dragBody ) -- make object draggable
    end

    return true
  end

  background:addEventListener( "touch", spawnDisk ) -- touch the screen to create disks
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