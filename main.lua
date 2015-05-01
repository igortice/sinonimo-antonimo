---------------------------------------------------------------------------------
--
-- main.lua
--
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Function Main
---------------------------------------------------------------------------------
local function main( )
  -- Requires globais
  ---------------------------------------------------------------------------------
  require 'print_r'
  require 'functions'


  -- Background global
  ---------------------------------------------------------------------------------
  background_sheet        = require("bg_sheets")
  background_sheet_sprite = graphics.newImageSheet( "images/bg_spritesheet.png", background_sheet:getSheet() )


  -- Hidden status bar
  ---------------------------------------------------------------------------------
  display.setStatusBar( display.HiddenStatusBar )


  -- Variaveis globais
  ---------------------------------------------------------------------------------
  centerX   = display.contentCenterX
  centerY   = display.contentCenterY

  _W        = display.contentWidth
  _H        = display.contentHeight

  popSound    = audio.loadSound ("sounds/pop2_wav.wav")
  buzzSound   = audio.loadSound ("sounds/buzz.mp3")


  local loadsave = require( "loadsave" )
  -- loadsave.changeDefault(system.ResourceDirectory)
  data          = {}
  data.settings = loadsave.loadTable( "settings.json" )

  if ( data.settings == nil ) then
      data.settings                   = {}
      data.settings.musicOn           = true
      data.settings.soundOn           = true
      data.settings.difficulty        = "easy"
      data.settings.highScore         = 0
      data.settings.fases_liberadas   = 1
      data.settings.questions         = '[[{"palavra":"casa","resposta":"lar"}],[{"palavra":"hate","resposta":"odio"}]]'
      loadsave.saveTable( data.settings, "settings.json" )
  end

  -- Load tela inicial
  ---------------------------------------------------------------------------------
  local composer = require "composer"
  composer.gotoScene( "game_over", { effect = "zoomInOutFade", time = 500 } )
end


---------------------------------------------------------------------------------
-- Init Function Main
---------------------------------------------------------------------------------
main( )