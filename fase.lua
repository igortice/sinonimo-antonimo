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

-- Configurar background
local function config_background( sceneGroup )
  local background_sheet        = require("bg_sheets")
  local background_sheet_sprite = graphics.newImageSheet( "images/bg_spritesheet.png", background_sheet:getSheet() )

  local background  = display.newImage( background_sheet_sprite , background_sheet:getFrameIndex("bg_blue3"))
  background.x      = display.contentCenterX
  background.y      = display.contentCenterY

  sceneGroup:insert( background )
end

-- Config global
local function config_global( sceneGroup )
  config_background( sceneGroup )
end


---------------------------------------------------------------------------------
-- Header
---------------------------------------------------------------------------------

-- Config count timer
local function config_count_timer( sceneGroup )
  local displayTime = display.newText({
     text     = "00:00",
     x        = 100,
     y        = 20,
     width    = 100,
     fontSize = 20
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

-- Config header
local function config_header( sceneGroup, event )
  local textField = display.newText({
     text     = event.params.level,
     x        = display.contentCenterX,
     y        = 20,
     width    = 100,
     fontSize = 20,
     align    = "center"
  })
  sceneGroup:insert( textField )
end


---------------------------------------------------------------------------------
-- Body
---------------------------------------------------------------------------------

-- Config body
local function config_body( sceneGroup )
end


---------------------------------------------------------------------------------
-- Footer
---------------------------------------------------------------------------------

-- Config footer
local function config_footer( sceneGroup )
end


function scene:create( event )
  local sceneGroup = self.view

  config_global( sceneGroup )

  config_header( sceneGroup, event )

  config_body( sceneGroup )

  config_footer( sceneGroup )
end

-- "scene:show()"
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then


      config_count_timer( sceneGroup )
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