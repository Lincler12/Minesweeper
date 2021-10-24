require_relative 'Board'
class Game
  def initialize(board_size = 3)
    @board = Board.new(board_size)
  end

  def play
    position = reveal_tile

  end

  def reveal_tile
    position = ""
    loop do
      position = choose_square
      break if tile_revealed?(position)
    end
    position
  end

  def choose_square
    position = ''
    loop do
      position = gets.chomp.split(',').map(&:to_i)
      return position if position_correct?(position)
      puts "Wrong input. Please try again."
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
