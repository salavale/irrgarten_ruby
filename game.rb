#encoding:utf-8
require_relative 'monster'
require_relative 'player'
require_relative 'labyrinth'
require_relative 'orientation'
require_relative 'game_state'
require_relative 'game_character'

module Irrgarten
 
    class Game 
        @@MAX_ROUNDS=10;
        @@N_ROWS=15;
        @@N_COLS=15;
        @@EXIT_ROW=5;
        @@EXIT_COL=14;
        
        def initialize(nplayers)
            @players= Array.new
            nplayers.times{ |i|
                aux = Player.new(i.to_s, Dice.random_intelligence, Dice.random_strength)
                @players << aux
            }

            @current_player_index = Dice.who_starts(nplayers)
            @current_player = @players[@current_player_index]
            
            @monsters = Array.new
            @labyrinth= Labyrinth.new(@@N_ROWS, @@N_COLS, @@EXIT_ROW, @@EXIT_COL)
            
            configure_labyrinth()
            @labyrinth.spread_players(@players)
            @log="- Game started\n"
        end

        def finished()
            return @labyrinth.have_a_winner
        end

        def next_step(preferred_direction)
            @log="";
            if(!@current_player.dead)
                direction=actual_direction(preferred_direction)
                if(direction!=preferred_direction)
                    log_player_no_orders
                end
                monster=@labyrinth.put_player(direction, @current_player)
                if(monster==nil)
                    log_no_monster
                else
                    winner=combat(monster)
                    manage_reward(winner)
                end
            else
                manage_resurrection
            end
            end_game=finished
            if(!end_game)
                next_player
            end
            return end_game
        end

        def game_state()
            jugadores="";
            monstruos="";
            
            @players.each do |j|
                jugadores+="- "+j.to_s+"\n"
            end 

            @monsters.each do |m|
                monstruos+="- "+m.to_s+"\n"
            end 
            todo= GameState.new(@labyrinth.to_s, jugadores, monstruos, @current_player_index, finished, @log)
            return todo
        end

        private 
        def configure_labyrinth()
            @labyrinth.add_block(Orientation::HORIZONTAL, 0, 0, @@N_ROWS)
            @labyrinth.add_block(Orientation::HORIZONTAL, 14, 0, @@N_ROWS)
            @labyrinth.add_block(Orientation::VERTICAL, 1, 14, @@N_COLS)
            @labyrinth.add_block(Orientation::VERTICAL,6 , 14, @@N_COLS)
            @labyrinth.add_block(Orientation::VERTICAL,1 , 0, @@N_COLS)
            @labyrinth.add_block(Orientation::VERTICAL,1 , 3, 2)
            @labyrinth.add_block(Orientation::VERTICAL,2,2,3)
            @labyrinth.add_block(Orientation::VERTICAL,6,2,4)
            @labyrinth.add_block(Orientation::VERTICAL,11,2,3)
            @labyrinth.add_block(Orientation::VERTICAL,6 , 3, 2)
            @labyrinth.add_block(Orientation::VERTICAL,9 , 3, 1)
            @labyrinth.add_block(Orientation::VERTICAL,11 , 3, 1)
            esqueleto= Monster.new("esqueleto", 4,1)
            @labyrinth.add_monster(5,5,esqueleto)
            zombie= Monster.new("zombie", 2,3)
            @labyrinth.add_monster(10,10,zombie)
            @labyrinth.add_monster(13,1,zombie)
        end
        def next_player()
            @players[@current_player_index]= @current_player #Guardamos la información del jugador actual
            @current_player_index=(@current_player_index+1)% @players.size #Avanzamos  al siguiente jugador
            @current_player = @players[@current_player_index] #Cambiamos al jugador actual
        end
        
        def actual_direction(preferred_direction)
            current_row=@current_player.row
            current_col=@current_player.col
            valid_moves=@labyrinth.valid_moves(current_row, current_col)
            return @current_player.move(preferred_direction, valid_moves)
        end

        def combat(monster)
            rounds=0
            winner=GameCharacter::PLAYER
            player_attack=@current_player.attack
            lose=monster.defend(player_attack)
            
            while((!lose)&&(rounds<@@MAX_ROUNDS))
                winner=GameCharacter::MONSTER
                rounds+=1
                monster_attack=monster.attack
                lose=@current_player.defend(monster_attack)
                if(!lose)
                    player_attack=@current_player.attack
                    winner=GameCharacter::PLAYER
                    lose=monster.defend(player_attack)
                end
            end
            log_rounds(rounds, @@MAX_ROUNDS)
            return winner
        end

        def manage_reward(winner)
            if(winner==GameCharacter::PLAYER)
                @current_player.receive_reward
                log_player_won
            else
                log_monster_won
            end
        end

        def manage_resurrection()
            resurrect=Dice.resurrect_player
            if(resurrect)
                @current_player.resurrect
                log_resurrected
            else
                log_player_skip_turn
            end
        end

        def log_player_won()
            @log+= "P"+@current_player.number+" won vs M\n"
        end
        def log_monster_won()
            @log+= "M won vs P"+@current_player.number+"\n"
        end
        def log_resurrected()
            @log+="P"+@current_player.number+" has resurrected\n"
        end
        def log_player_skip_turn()
            @log+="P"+@current_player.number+" lost its turn for being dead\n"
        end
        def log_player_no_orders()
            @log+="P"+@current_player.number+" could not follow the order\n"    
        end
        def log_no_monster()
            @log+="P"+@current_player.number+" moved to a emptycell or could not move\n"
        end
        def log_rounds(rounds, max)
            @log+="there has been "+rounds.to_s+" out of "+max.to_s+" combat rounds\n"
        end
    end 
end #module
