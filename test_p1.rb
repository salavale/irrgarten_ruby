#encoding:utf-8
require_relative 'dice'
require_relative 'directions'
require_relative 'game_character'
require_relative 'shield'
require_relative 'weapon'
require_relative 'game_state'
require_relative 'orientation'
require_relative 'monster'
require_relative 'game'

module Irrgarten

    class TestP1
        def self.main()
            #prueba weapon
            lanza=Weapon.new(3.1,2)
            puts "Lanza: "+lanza.to_s
            puts "Ataca"
            lanza.attack()
            puts "Lanza: "+lanza.to_s
            if(lanza.discard)
                puts "Me han descartado"
            else
                puts "No me han descartado"
            end

            #prueba weapon
            escudo=Shield.new(3.1,4)
            puts "\nEscudo: "+escudo.to_s
            puts "Defiende"
            escudo.protect()
            puts "Escudo: "+escudo.to_s
            if(escudo.discard)
                puts "Me han descartado"
            else
                puts "No me han descartado"
            end

            #Prueba GameState
            tablero=GameState.new("laberinto1", "Pepe Jose María Laura",
                "zombie esqueleto", 0, false, "vacio")
            puts "\nCaracterísticas del juego"
            puts ("laberinto: "+tablero.labyrinth)
            puts ("jugadores: "+tablero.players)
            puts ("enemigos: "+tablero.monsters)
            puts ("jugador actual: "+tablero.current_player.to_s)
            puts ("juego terminado: "+tablero.winner.to_s)
            puts ("Eventos especiales: "+tablero.log)

            #Prueba enums
            mirada=Orientation::HORIZONTAL
            zombie=GameCharacter::MONSTER 
            mover=Directions::LEFT 

            #Prueba Dice
            contador_cero=0
            contador_max=0
            contador_promedio=0

            contador_revivido=0

            for i in (0...100) do
                if(Dice::discard_element(0))
                    contador_cero += 1
                end
                if(Dice::discard_element(5))
                    contador_max += 1
                end
                if(Dice::discard_element(3))
                    contador_promedio += 1
                end

                if(Dice::resurrect_player)
                    contador_revivido += 1
                end
            end
            puts ("Prob de descarte de 0: "+(contador_cero.fdiv(100)).to_s)
            puts "Prob de descarte del Max: "+(contador_max.fdiv(100)).to_s
            puts "Prob de descarte de promedio: "+(contador_promedio.fdiv(100)).to_s
            
            puts "Prob de revivir: "+(contador_revivido.fdiv(100)).to_s 
            
            pos_max=32
            num_jugadores=4
            competencia=4.3
            for i in 0...100 do
                posicion=Dice.random_pos(pos_max)
                if(0>posicion||posicion>pos_max)
                    puts "Error en la posicion"
                end
            end
            esqueleto=Monster.new("esqueleto", 3,4)
            puts esqueleto.to_s

            juego=Game.new(3)
            total=juego.game_state
            puts total.labyrinth
        end
    end

    TestP1.main()

end #module