require_relative 'Board'
class Game
  def initialize(number_of_bombs = 9,board_size = 9)
    @board = Board.new(number_of_bombs, board_size)
  end

  def play
    loop do
      position = reveal_tile
      if tile_has_bomb?(position)
        puts 'You lost, tile has a bomb!'
        @board.render
        return
      end
      reveal_neighbor_tiles(position)
      if win?
        puts "Congrats! You've won!"
      end
    end
  end

  def reveal_neighbor_tiles(pos)
    row,col = pos
    tile = @board.grid[row][col]
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

  def reveal_tile
    position = ''
    loop do
      position = get_user_input
      break if tile_revealed?(position)
      puts "Tile is already revealed"
      
    end
    position
  end

  def get_user_input
    position = ''
    loop do
      puts "Enter a position"
      position = gets.chomp.split(',').map(&:to_i)
      return position if position_correct?(position)

      puts 'Wrong input. Please try again.'
    end
  end

  def tile_revealed?(pos)
    @board.tile_revealed?(pos)
  end

  def position_correct?(pos)
    @board.position_correct?(pos)
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
end
