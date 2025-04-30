#encoding:utf-8
require_relative 'dice'

module Irrgarten

    class Weapon

        def initialize(p,u)
            @power=p
            @uses=u
        end

        def attack()
            ataque=0.0
            if(@uses>0)
                @uses-=1
                ataque=@power
                #PREGUNTAR PREGUNTAR PREGUNTAR PREGUNTAR PREGUNTAR PREGUNTAR PREGUNTAR PREGUNTAR 
            end
            return ataque
        end

        def to_s()
            "W["+@power.to_s+", "+@uses.to_s+"]"
        end

        def discard()
            Dice.discard_element(@uses)
        end
    end
end #module