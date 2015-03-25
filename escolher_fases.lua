---------------------------------------------------------------------------------
--
-- escolher_fases.lua
--
---------------------------------------------------------------------------------

local composer  = require "composer"
local scene     = composer.newScene()

---------------------------------------------------------------------------------
-- Config Global
---------------------------------------------------------------------------------

-- Config data questions
local data_questions
local function config_data_questions( )
  local json      = require "json"
  local json_data = '[[{"palavra":"casa","resposta":"lar"},{"palavra":"trabalho","resposta":"emprego"}]]'
  data_questions  = json.decode(json_data)
end

-- Configurar background
local function config_background( sceneGroup )
  local background_sheet        = require("bg_sheets")
  local background_sheet_sprite = graphics.newImageSheet( "images/bg_spritesheet.png", background_sheet:getSheet() )

  local background  = display.newImage( background_sheet_sprite , background_sheet:getFrameIndex("bg_blue2"))
  background.x      = display.contentCenterX
  background.y      = display.contentCenterY

  sceneGroup:insert( background )
end

-- Config global
local function config_global( sceneGroup )
  config_background( sceneGroup )

  config_data_questions()
end


---------------------------------------------------------------------------------
-- Header
---------------------------------------------------------------------------------

-- Config header
local function config_header( sceneGroup )
  local texto_head        = display.newText( "Fases", 0, 0, native.systemFontBold, 20 )
  texto_head.x, texto_head.y  = display.contentCenterX, 50
  texto_head:setFillColor( 255 )
  sceneGroup:insert( texto_head )
end


---------------------------------------------------------------------------------
-- Body
---------------------------------------------------------------------------------
local fases_liberadas = 1

-- Config diplay fases body
local function config_display_fases( sceneGroup )
  local function onFaseTouch( self, event )
    if event.phase == "began" then
      audio.play( popSound )
      self.alpha = 1
      local options = {
          effect  = "zoomInOutFade",
          time    = 500,
          params  = { level="Fase " .. self.fase, questions = data_questions[self.fase]}
      }
      composer.gotoScene( "fase", options )
    elseif event.phase == "ended" or event.phase == "cancelled" then
      self.alpha = 0.25
    end

    return true
  end

  local tamanho_rec = display.contentWidth * 0.20
  local init_rect_x = {10, 100, 188}
  local x, y        = 0, 0
  for numero_fase=1,12 do
    if numero_fase % 3 ~= 0 then
      x = numero_fase % 3
      if (numero_fase % 3  == 1) then
        y = y + 80
      end
    else
      x = 3
    end
    local retangulo       = display.newRoundedRect( tamanho_rec + init_rect_x[x], tamanho_rec + y, tamanho_rec, tamanho_rec, 18 )

    retangulo.strokeWidth = 2
    retangulo.alpha       = 0.5
    retangulo.touch       = onFaseTouch
    retangulo.fase        = numero_fase
    retangulo:setFillColor( 0 )
    sceneGroup:insert( retangulo )

    local glyphicons        = require("glyphicons")
    local glyphicons_sprite = graphics.newImageSheet("glyphicons/glyphicons_sprites2.png", glyphicons:getSheet())
    if fases_liberadas < numero_fase then
      local icon      = display.newImage(glyphicons_sprite, glyphicons:getFrameIndex("lock"))
      icon.x, icon.y  = retangulo.x, retangulo.y
      icon.width, icon.height = 20, 20
      sceneGroup:insert( icon )
    else
      local texto_numero_fase                   = display.newText( numero_fase, 0, 0, native.systemFontBold, 24 )
      texto_numero_fase.x, texto_numero_fase.y  = retangulo.x, retangulo.y
      texto_numero_fase:setFillColor( 255 )
      sceneGroup:insert( texto_numero_fase )
      retangulo:addEventListener( "touch", retangulo )
    end
  end
end

-- Config body
local function config_body( sceneGroup )
  config_display_fases( sceneGroup )
end


function scene:create( event )
  local sceneGroup = self.view

  config_global( sceneGroup )

  config_header( sceneGroup )

  config_body( sceneGroup )
end

-- "scene:show()"
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
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