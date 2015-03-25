---------------------------------------------------------------------------------
--
-- fase.lua
--
---------------------------------------------------------------------------------

local composer  = require "composer"
local scene     = composer.newScene()

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

-- Configurar background
local function config_background( sceneGroup )
  local background_sheet        = require("bg_sheets")
  local background_sheet_sprite = graphics.newImageSheet( "images/bg_spritesheet.png", background_sheet:getSheet() )

  local background  = display.newImage( background_sheet_sprite , background_sheet:getFrameIndex("bg_blue3"))
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
local function config_lifes( sceneGroup )
  local glyphicons        = require("glyphicons")
  local glyphicons_sprite = graphics.newImageSheet("glyphicons/glyphicons_sprites2.png", glyphicons:getSheet())

  for i=1,quantidade_lifes do
    local icon      = display.newImage(glyphicons_sprite, glyphicons:getFrameIndex("heart"))

    if quantidade_erros >= i then
      icon      = display.newImage(glyphicons_sprite, glyphicons:getFrameIndex("heart_empty"))
    end

    icon.width, icon.height = 15, 15
    icon.x, icon.y  = _W - 115 + (i*20), 20
    sceneGroup:insert( icon )
  end
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

local repostas_ok = 0, pergunta, resposta, resposta_array

local function set_resposta( event )
  resposta        = event.params.questions[repostas_ok + 1].resposta
  resposta_array  = to_array( resposta )
  result_resposta = ''
  for i=1,#resposta do
    local palavra = '__'
    if i == 2 then
      palavra = resposta_array[i]
    end
    result_resposta = result_resposta .. palavra .. ' '
  end

  return result_resposta
end

local function set_pergunta( event )
  return event.params.questions[repostas_ok + 1].palavra
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

-- Config body
local function config_body( sceneGroup, event )
  config_questions( sceneGroup, event )
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