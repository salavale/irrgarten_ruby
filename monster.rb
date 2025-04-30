#encoding:utf-8
require_relative 'dice'

module Irrgarten
        
    class Monster
        @@INITIAL_HEALTH = 5
        @@OUT_OF_BOUNDS = -1
        
        def initialize(name, intelligence, strength)
            @name=name
            @intelligence=intelligence
            @strength=strength
            @row = @@OUT_OF_BOUNDS
            @col = @@OUT_OF_BOUNDS
            @health = @@INITIAL_HEALTH
        end

        def dead()
            return @health <=0
        end

        def attack()
            return Dice.intensity(@strength)
        end

        def defend(received_attack)
            is_dead = dead()
                if(!is_dead)
                    defensive_energy = Dice.intensity(@intelligence);
                    if(defensive_energy < received_attack)
                        #Monster vivo y recive hit
                        got_wounded()
                        is_dead=dead()
                    end
                end
                return is_dead;
        end

        def setPos(row, col)
            @row=row
            @col=col
        end

        def to_s()
            @name+"(M):["+"HP("+@health.to_s+") STR("+@strength.to_s+") "+"INT("+@intelligence.to_s+") POS("+@row.to_s+","+@col.to_s+")]"
        end

        private 
        def got_wounded()
            @health-=1
        end
        
    end
end #module