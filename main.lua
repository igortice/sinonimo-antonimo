local function main( )
  -- hidden status bar
  display.setStatusBar( display.HiddenStatusBar )

  local composer = require "composer"

  require 'print_r'
  require 'functions'

  centerX = display.contentCenterX
  centerY = display.contentCenterY
  _W = display.contentWidth
  _H = display.contentHeight

  popSound = audio.loadSound ("sounds/pop2_wav.wav")

  -- load first scene
  composer.gotoScene( "escolher_fases", { effect = "zoomInOutFade", time = 500 } )
end

main()