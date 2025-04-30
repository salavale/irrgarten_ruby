#encoding:utf-8
require_relative 'dice'
require_relative 'shield'
require_relative 'weapon'
require_relative 'directions'

module Irrgarten
        
    class Player
        @@MAX_WEAPONS=2
        @@MAX_SHIELDS=3
        @@INITIAL_HEALTH=10
        @@HITS2LOSE=3
        @@OUT_OF_BOUNDS = -1
        
        def initialize(number, intelligence, strength)    
            @number=number
            @name="Player"+number.to_s
            @intelligence=intelligence
            @strength=strength
            @health=@@INITIAL_HEALTH
            @consecutive_hits=0
            @weapons = Array.new
            @shields = Array.new
            @row = @@OUT_OF_BOUNDS
            @col = @@OUT_OF_BOUNDS
        end 
        def resurrect()
            @weapons.clear
            @shields.clear
            @health=@@INITIAL_HEALTH
            @consecutive_hits=0
        end
        def row
            @row
        end
        def col
            @col
        end
        def number()
            number=@number
            number
        end
        def set_pos(row, col)
            @row=row
            @col=col
        end
        def dead()
            return @health <=0
        end 
        def move(direction, validMoves)
            size = validMoves.size
            contained = validMoves.include?(direction)
            if((size>0)&&(!contained))
                return validMoves[0]
            else
                return direction
            end
        end

        def attack()
            return @strength+sum_weapons()
        end

        def defend(received_attack)
            manage_hit(received_attack)
        end

        def receive_reward()
            w_reward=Dice.weapons_reward()
            s_reward=Dice.shields_reward()
            
            w_reward.times{
                receive_weapons(new_weapon)
            }

            s_reward.times{
                receive_shields(new_shield)
            }

            @health+=Dice.health_reward
        end

        def to_s()
            str=@name+"(P):["+"HP("+@health.to_s+") STR("+@strength.to_s+") "+"INT("+@intelligence.to_s+") POS("+@row.to_s+","+@col.to_s+")]"
            str+="\n\tWeapons["
            ((@weapons.size)-1).times{ |w|
                str+=@weapons[w].to_s+", "
            }
            str+=@weapons[@weapons.size-1].to_s+"]"
            str+="\n\tShields["
            ((@shields.size)-1).times{ |s|
                str+=@shields[s].to_s+", "
            }
            str+=@shields[@shields.size-1].to_s+"]\n"
            str
        end

        private 
            def receive_weapons(w)
                @weapons.delete_if do |w_i|
                    w_i.discard
                end

                if(@weapons.size<@@MAX_WEAPONS)
                    @weapons << w
                end 
            end

            def receive_shields(s)
                @shields.delete_if do |s_i|
                    s_i.discard
                end

                if(@shields.size<@@MAX_SHIELDS)
                    @shields << s
                end 
            end 
            
            def new_weapon()
                Weapon.new(Dice.weapon_power(),Dice.uses_left())
            end
            
            def new_shield()
                Shield.new(Dice.shield_power(), Dice.uses_left())
            end 
            
            def sum_weapons()
                sum=0
                for w in @weapons
                    sum+=w.attack
                end
                sum
            end
            
            def sum_shields()
                sum=0
                for s in @shields
                    sum+=s.protect
                end
                sum
            end
            
            def defensive_energy()
                return @intelligence+sum_shields()
            end
            
            def manage_hit(received_attack)
                lose=false
                defense = defensive_energy
                if(defense<received_attack)
                    got_wounded
                    inc_consecutive_hits
                else
                    reset_hits
                end
                
                if((@consecutive_hits==@@HITS2LOSE)||dead())
                    reset_hits
                    lose=true
                else
                    lose=false
                end
                return lose
            end 
            
            def reset_hits()
                @consecutive_hits=0
            end 
            
            def got_wounded()
                @health-=1
            end 
            
            def inc_consecutive_hits()
                @consecutive_hits+=1
            end 
    end
end #module