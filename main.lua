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


  -- Hidden status bar
  ---------------------------------------------------------------------------------
  display.setStatusBar( display.HiddenStatusBar )


  -- Variaveis globais
  ---------------------------------------------------------------------------------
  centerX   = display.contentCenterX
  centerY   = display.contentCenterY

  _W        = display.contentWidth
  _H        = display.contentHeight

  popSound  = audio.loadSound ("sounds/pop2_wav.wav")


  -- Load tela inicial
  ---------------------------------------------------------------------------------
  local composer = require "composer"
  composer.gotoScene( "tela_inicial", { effect = "zoomInOutFade", time = 500 } )
end


---------------------------------------------------------------------------------
-- Init Function Main
---------------------------------------------------------------------------------
main( )