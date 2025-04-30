#encoding:utf-8
require_relative 'monster'
require_relative 'player'

module Irrgarten

    class Labyrinth 
        @@BLOCK_CHAR='X';
        @@EMPTY_CHAR='-';
        @@MONSTER_CHAR='M';
        @@COMBAT_CHAR='C';
        @@EXIT_CHAR='E';
        @@ROW=0;
        @@COL=1;
        @@INIT_POINT=0;
        
        def initialize(n_rows, n_cols, exit_row, exit_col)
            @n_rows=n_rows;
            @n_cols=n_cols;
            @exit_row=exit_row;
            @exit_col=exit_col;
            @lab_player=Array.new(@n_rows) {Array.new(@n_cols)}
            @lab_monster=Array.new(@n_rows) {Array.new(@n_cols)}
            @lab_square=Array.new(@n_rows) {Array.new(@n_cols, @@EMPTY_CHAR)}
            @lab_square[@exit_row][@exit_col]=@@EXIT_CHAR;
        end

        def spread_players(players)
            players.each do |p|
                pos=random_empy_pos
                put_player_2d(@@INIT_POINT,@@INIT_POINT,pos[@@ROW], pos[@@COL],p)
            end
        end
        
        def have_a_winner()
            return @lab_player[@exit_row][@exit_col]!=nil
        end
        
        def to_s()
            map=""
            @n_rows.times{ |i|
                @n_cols.times{ |j|
                    map+=@lab_square[i][j].to_s+" "
                }
                map+="\n"
            }
            return map
        end

        def add_monster(row, col, monster)
            if(pos_ok(row, col))
                @lab_monster[row][col]=monster;
                @lab_square[row][col]=@@MONSTER_CHAR;
            end
        end

        def put_player(direction, player)
            old_row=player.row
            old_col=player.col
            new_pos=dir_2_pos(old_row, old_col, direction);
            
            monster=put_player_2d(old_row, old_col, new_pos[@@ROW], new_pos[@@COL], player)
            
            return monster
        end 

        def add_block(orientation, start_row, start_col, length)
            inc_row=0
            inc_col=0
            if(orientation==Orientation::VERTICAL)
                inc_row=1
                inc_col=0
            else
                inc_row=0
                inc_col=1
            end

            row=start_row
            col=start_col

            while((pos_ok(row,col)&&empty_pos(row,col))&&(length>0))
                @lab_square[row][col]=@@BLOCK_CHAR
                length-=1
                row+=inc_row
                col+=inc_col
            end
        end

        def valid_moves(row, col)
            output= Array.new
            if(can_step_on(row+1,col))
                output << Directions::DOWN
            end
            if(can_step_on(row-1,col))
                output << Directions::UP
            end 
            if(can_step_on(row,col+1))
                output << Directions::RIGHT
            end
            if(can_step_on(row,col-1))
                output << Directions::LEFT
            end
            return output
        end

        private
        def pos_ok(row, col)
            return (row<@n_rows)&&(col<@n_cols)
        end
        def empty_pos(row, col)
            return @lab_square[row][col]==@@EMPTY_CHAR
        end
        def monster_pos(row, col)
            return @lab_square[row][col]==@@MONSTER_CHAR
        end
        def exit_pos(row, col)
            return @lab_square[row][col]==@@EXIT_CHAR
        end
        def combat_pos(row, col)
            return @lab_square[row][col]==@@COMBAT_CHAR
        end
        def can_step_on(row, col)
            return pos_ok(row, col)&&((empty_pos(row,col))||(monster_pos(row,col))||(exit_pos(row,col)))
        end
        def update_old_pos(row, col)
            if(pos_ok(row,col))
                if(combat_pos(row,col))
                    @lab_square[row][col]=@@MONSTER_CHAR;
                else
                    @lab_square[row][col]=@@EMPTY_CHAR;
                end
            end
        end
        def dir_2_pos(row, col, direction)
            pos_fin=[row,col]
            case direction
            when Directions::LEFT
                pos_fin[@@ROW]=row
                pos_fin[@@COL]=col-1
            when Directions::RIGHT
                pos_fin[@@ROW]=row
                pos_fin[@@COL]=col+1
            when Directions::UP
                pos_fin[@@ROW]=row-1
                pos_fin[@@COL]=col
            when Directions::DOWN
                pos_fin[@@ROW]=row+1
                pos_fin[@@COL]=col
            end 
            pos_fin
        end
        def random_empy_pos()
            pos_random=[@@ROW,@@COL]
            pos_random[@@ROW]=Dice.random_pos(@n_rows)
            pos_random[@@COL]=Dice.random_pos(@n_cols)
            until empty_pos(pos_random[@@ROW],pos_random[@@COL]) do
                pos_random[@@ROW]=Dice.random_pos(@n_rows)
                pos_random[@@COL]=Dice.random_pos(@n_cols)
            end
            pos_random
        end
        def put_player_2d(old_row, old_col, row, col, player)
            output = nil
            if(can_step_on(row,col))
                if(pos_ok(old_row,old_col))
                    if(@lab_player[old_row][old_col]==player)
                        update_old_pos(old_row, old_col)
                        @lab_player[old_row][old_col]=nil
                    end
                end
                monster_pos=monster_pos(row, col)
                if(monster_pos)
                    @lab_square[row][col]=@@COMBAT_CHAR
                    output=@lab_monster[row][col]
                else
                    number=player.number
                    @lab_square[row][col]=number
                end
                @lab_player[row][col]=player
                player.set_pos(row, col)
            end
            return output
        end 
    end
end #module