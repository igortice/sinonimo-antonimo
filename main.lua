local function main( )
  -- hidden status bar
  display.setStatusBar( display.HiddenStatusBar )

  -- set background
  local background = display.newImage( "images/furacao.png", display.contentCenterX, display.contentCenterY )

  local texto_iniciar = display.newText( "Iniciar Jogo", display.contentCenterX, display.contentCenterY, native.systemFont, 24 )
  texto_iniciar:setFillColor( 0,0,1 )

  local function fase_um( event )
    if ( event.phase == "began" ) then
      local composer = require( "composer" )
      composer.gotoScene( "fase1", { effect = "fade", time = 500 } )
    end
  end

  texto_iniciar:addEventListener( "touch", fase_um )
end

main()