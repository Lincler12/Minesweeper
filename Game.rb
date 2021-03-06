require_relative 'Board'
class Game
  attr_accessor :finished
  def initialize(number_of_bombs = 9, board_size = 9)
    @finished = false
    @board = Board.new(number_of_bombs, board_size)
  end

  def play
    loop do
      tile = select_tile
      case user_options_prompt(tile)
      when 'f'
        flag_tile(tile)
        @board.render
        next
      when 'q'
        unselect_tile(tile)
        break
      else
        if tile_has_bomb?(tile)
          puts 'You lost, tile has a bomb'
          @finished = true
          tile_reveal(tile)
          @board.render
          break
        end
        reveal_neighbor_tiles(tile)
        if win?
          @finished = true
          puts "Congrats! You've won!"
          break
        end
      end
    end
  end

  def unselect_tile(tile)
    @board.unselect_tile(tile)
  end

  def reveal_neighbor_tiles(tile)
    tile.hide
    @board.reveal_neighbor_tiles(tile)
    @board.render
  end

  def win?
    @board.win?
  end

  def tile_has_bomb?(pos)
    @board.tile_has_bomb?(pos)
  end

  def select_tile
    tile = nil
    loop do
      tile = get_user_input
      if selected_tile?(tile)
        @board.render
        tile.selected = false
        break
      end
      puts 'Tile is already revealed'
    end
    tile
  end

  def flag_tile(tile)
    @board.flag_tile(tile)
  end

  def user_options_prompt(_tile)
    puts 'Press f to flag'
    puts 'enter to reveal'
    puts 'q to quit'
    user_input = gets.chomp
  end

  def selected_tile?(tile)
    @board.selected_tile?(tile)
  end

  def get_user_input
    position = ''
    loop do
      puts 'Enter a position ex (row,col)'
      position = gets.chomp.split(',').map(&:to_i)
      row, col = position
      tile = @board.grid[row][col]
      return tile if position_correct?(position)

      puts 'Wrong input. Please try again.'
    end
  end

  def tile_reveal(tile)
    @board.tile_reveal(tile)
  end

  def position_correct?(pos)
    @board.position_correct?(pos)
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new(1, 3)
  game.play
end
