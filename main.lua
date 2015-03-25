local function main( )
  -- hidden status bar
  display.setStatusBar( display.HiddenStatusBar )

  -- require controller module
  local composer = require "composer"

  -- load first scene
  composer.gotoScene( "tela_inicial", { effect = "zoomInOutFade", time = 500 } )
end

main()