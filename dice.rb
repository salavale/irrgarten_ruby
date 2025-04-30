#encoding:utf-8
module Irrgarten
    class Dice
        @@MAX_USES = 5 #(número máximo de usos de armas y escudos)
        @@MAX_INTELLIGENCE = 10.0 #(valor máximo para la inteligencia de jugadores y monstruos)
        @@MAX_STRENGTH = 10.0 #(valor máximo para la fuerza de jugadores y monstruos)
        @@RESURRECT_PROB = 0.3 #(probabilidad de que un jugador sea resucitado en cada turno)
        @@WEAPONS_REWARD = 2 #(numero máximo de armas recibidas al ganar un combate)
        @@SHIELDS_REWARD = 3 #(numero máximo de escudos recibidos al ganar un combate)
        @@HEALTH_REWARD = 5 #(numero máximo de unidades de salud recibidas al ganar un combate)
        @@MAX_ATTACK = 3 #(máxima potencia de las armas)
        @@MAX_SHIELD = 2 #(máxima potencia de los escudos)

        @@generator=Random.new

        def self.random_pos(max)
            @@generator.rand(max)
        end

        def self.who_starts(nplayers)
            @@generator.rand(nplayers)
        end

        def self.random_intelligence()
            @@generator.rand(0.0...@@MAX_INTELLIGENCE)
        end

        def self.random_strength()
            @@generator.rand(0.0...@@MAX_STRENGTH)
        end

        def self.resurrect_player()
            if(@@generator.rand()<@@RESURRECT_PROB)
                return true
            else
                return false
            end
        end

        def self.weapons_reward()
            @@generator.rand(0..@@WEAPONS_REWARD)
        end

        def self.shields_reward()
            @@generator.rand(0..@@SHIELDS_REWARD)
        end

        def self.health_reward()
            @@generator.rand(0..@@HEALTH_REWARD)
        end

        def self.weapon_power()
            @@generator.rand(0.0...@@MAX_ATTACK)
        end

        def self.shield_power()
            @@generator.rand(0.0...@@MAX_SHIELD)
        end

        def self.uses_left()
            @@generator.rand(0..@@MAX_USES)
        end

        def self.intensity(competence)
            @@generator.rand(0.0...competence)
        end

        def self.discard_element(uses_left)
            if(uses_left<=@@MAX_USES*@@generator.rand())
                return true
            else
                return false
            end
        end
    end
end #module