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

  local popSound    = audio.loadSound ("assets/sounds/pop2_wav.wav")
  local buzzSound   = audio.loadSound ("assets/sounds/buzz.mp3")

  local loadsave  = require( "loadsave" )
  data            = {}
  data.settings   = loadsave.loadTable( "settings.json" )

  if ( data.settings == nil ) then
  -- if ( true ) then
      data.settings                   = {}
      data.settings.musicOn           = true
      data.settings.soundOn           = true
      data.settings.difficulty        = "easy"
      data.settings.highScore         = 0
      data.settings.fases_liberadas   = 1
      data.settings.questions         = '[[{"palavra":"que é o que anda com os pés na cabeça?","resposta":"piolho"},{"palavra":"é surdo e mudo, mas conta tudo?","resposta":"livro"},{"palavra":"fica cheio durante o dia e vazia a noite?","resposta":"sapato"},{"palavra":"passaro brasileiro palíndromo?","resposta":"arara"},{"palavra":"fruta que tem a semente por fora da casca?","resposta":"caju"},{"palavra":"cai em pé e corre deitado?","resposta":"chuva"},{"palavra":"quanto mais se perde mais se tem?","resposta":"sono"}],[{"palavra":"protocolo de comunicação usado entre duas ou mais máquinas?","resposta":"ip"},{"palavra":"um dos protocolos sob os quais assenta o núcleo da Internet?","resposta":"tcp"},{"palavra":"é o protocolo padrão para envio de e-mails através da Internet?","resposta":"smtp"},{"palavra":"protocolo de gerenciamento de correio eletrônico?","resposta":"imap"},{"palavra":"protocolo bastante rápida e versátil de transferir arquivos?","resposta":"ftp"},{"palavra":"protocolo de rede que permitem a conexão com outro computador?","resposta":"ssh"},{"palavra":"é um protocolo de serviço TCP/IP?","resposta":"dhcp"}]]'
      loadsave.saveTable( data.settings, "settings.json" )
  end

  function play_pop_sound( )
    if (data.settings.soundOn) then
        audio.play( popSound )
    end

    return
  end

  function play_buzz_sound( )
    if (data.settings.soundOn) then
        audio.play( buzzSound )
    end

    return
  end

  function animar_pulsate( objeto, scale_init, scale_end )
    local function1
    local trans

    local si = scale_init or 1.5
    local se = scale_end  or 1

    local function function1(e)
      trans = transition.to(objeto, { time = 500, xScale = se, yScale = se, transition = easing.linear})
    end

    transition.to(objeto, { time = 500, delay = 500, xScale = si, yScale = si, transition = easing.linear, onComplete=function1})

    return
  end

  -- Load tela inicial
  ---------------------------------------------------------------------------------
  local composer = require "composer"
  composer.gotoScene( "tela_inicial", { effect = "zoomInOutFade", time = 500 } )
end


---------------------------------------------------------------------------------
-- Init Function Main
---------------------------------------------------------------------------------
main( )