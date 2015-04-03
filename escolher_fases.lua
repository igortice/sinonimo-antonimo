---------------------------------------------------------------------------------
--
-- escolher_fases.lua
--
---------------------------------------------------------------------------------

local composer  = require "composer"
local scene     = composer.newScene()

local background_sheet        = require("bg_sheets")
local background_sheet_sprite = graphics.newImageSheet( "images/bg_spritesheet.png", background_sheet:getSheet() )

local glyphicons        = require("glyphicons")
local glyphicons_sprite = graphics.newImageSheet("glyphicons/glyphicons_sprites2.png", glyphicons:getSheet())
---------------------------------------------------------------------------------
-- Config Global
---------------------------------------------------------------------------------

-- Config data questions
---------------------------------------------------------------------------------
local data_questions

local function config_data_questions( )
  local json      = require "json"
  local json_data = '[[{"palavra":"casa","resposta":"lar"},{"palavra":"trabalho","resposta":"emprego"}]]'
  data_questions  = json.decode(json_data)
end

-- Config background
---------------------------------------------------------------------------------
local function config_background( sceneGroup )
  local background  = display.newImage( background_sheet_sprite , background_sheet:getFrameIndex("bg_blue2"))
  background.x      = centerX
  background.y      = centerY

  sceneGroup:insert( background )
end

-- Config global
---------------------------------------------------------------------------------
local function config_global( sceneGroup )
  config_background( sceneGroup )

  config_data_questions()
end


---------------------------------------------------------------------------------
-- Header
---------------------------------------------------------------------------------

-- Config header
---------------------------------------------------------------------------------
local function config_header( sceneGroup )
  local texto_head        = display.newText( "Fases", 0, 0, native.systemFontBold, 20 )
  texto_head.x, texto_head.y  = centerX, 50
  texto_head:setFillColor( 255 )
  sceneGroup:insert( texto_head )
end


---------------------------------------------------------------------------------
-- Body
---------------------------------------------------------------------------------

-- Config diplay fases body
---------------------------------------------------------------------------------
local fases_liberadas = 1

local function config_display_fases( sceneGroup )
  local function onFaseTouch( self, event )
    if event.phase == "began" then
      audio.play( popSound )
      self.alpha = 1
      local options = {
          effect  = "zoomInOutFade",
          time    = 500,
          params  = {
            fase              = self.fase,
            etapa             = 1,
            tempo             = "00:00",
            questions         = data_questions[self.fase],
            quantidade_erros  = 0
          }
      }
      composer.gotoScene( "fase", options )
    elseif event.phase == "ended" or event.phase == "cancelled" then
      self.alpha = 0.25
    end

    return true
  end

  local tamanho_rec = _W * 0.20
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

    local disk_yellow = display.newImage("images/puck_yellow.png")

    disk_yellow.x, disk_yellow.y  = tamanho_rec + init_rect_x[x], tamanho_rec + y
    disk_yellow.xScale, disk_yellow.yScale = 0.5, 0.5
    disk_yellow.touch       = onFaseTouch
    disk_yellow.fase        = numero_fase
    sceneGroup:insert( disk_yellow )

    if fases_liberadas < numero_fase then
      local icon      = display.newImage(glyphicons_sprite, glyphicons:getFrameIndex("lock"))
      icon.x, icon.y  = disk_yellow.x, disk_yellow.y
      icon.width, icon.height = 18, 20
      sceneGroup:insert( icon )
    else
      local texto_numero_fase                   = display.newText( numero_fase, 0, 0, native.systemFontBold, 24 )
      texto_numero_fase.x, texto_numero_fase.y  = disk_yellow.x, disk_yellow.y
      texto_numero_fase:setFillColor( 255 )
      sceneGroup:insert( texto_numero_fase )
      disk_yellow:addEventListener( "touch", disk_yellow )
    end
  end
end

-- Config body
---------------------------------------------------------------------------------
local function config_body( sceneGroup )
  config_display_fases( sceneGroup )
end

-- "scene:create()"
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
      composer.removeScene( "tela_inicial" )

      composer.removeScene( "fase" )

      if (event.params) then
        print_r(event.params)
        local options = {
            effect  = "flipFadeOutIn",
            params  = event.params
        }
        composer.gotoScene( "fase", options )
      end
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