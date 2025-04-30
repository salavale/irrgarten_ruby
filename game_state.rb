#encoding:utf-8

module Irrgarten
    class GameState

        def initialize(labyrinth, players, monsters, current_player, winner, log)
            @labyrinth=labyrinth
            @players=players
            @monsters=monsters
            @current_player=current_player
            @winner=winner
            @log=log
        end

        def labyrinth
            @labyrinth
        end

        def players
            @players
        end

        def monsters
            @monsters
        end

        def current_player
            @current_player
        end

        def winner
            @winner
        end

        def log
            @log
        end
    end
end #module