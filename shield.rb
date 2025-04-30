#encoding:utf-8
require_relative 'dice'

module Irrgarten
    class Shield

        def initialize(p,u)
            @protection=p
            @uses=u
        end

        def protect()
            defensa=0.0
            if(@uses>0)
                @uses-=1
                defensa=@protection
            end
            return defensa
        end

        def to_s()
            "S["+@protection.to_s+", "+@uses.to_s+"]"
        end

        def discard()
            Dice.discard_element(@uses)
        end
    end
end #module