#encoding:utf-8
require_relative 'Controller/controller'
require_relative 'UI/textUI'
require_relative 'game'

module Irrgarten
    NUM_PLAYERS = 1

    vista=UI::TextUI.new
    juego=Game.new(NUM_PLAYERS)

    controller=Control::Controller.new(juego, vista)
    controller.play
end
