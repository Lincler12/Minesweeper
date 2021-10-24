require 'byebug'
require_relative 'Tile'
class Board
  attr_reader :grid

  def initialize(number_of_bombs, board_side_size)
    @board_side_size = board_side_size
    @number_of_bombs = number_of_bombs
    @bomb_positions = []
    generate_bombs
    init_grid
  end

  def generate_bombs
    number_of_bombs.times do
      loop do
        row = rand(@board_side_size)
        col = rand(@board_side_size)
        next if @bomb_positions.include?([row, col])

        @bomb_positions << [row, col]
        break
      end
    end
  end

  def init_grid
    @grid = Array.new(@board_side_size) { Array.new(@board_side_size) { Tile.new('empty') } }

    @bomb_positions.each { |row, col| @grid[row][col].insert_bomb }
  end

  # Win condition: Each tile is revealed other than the ones with bomb
  def win?
    @board_side_size.times do |row|
      @board_side_size.times do |col|
        next if @bomb_positions.include?([row, col])
        return false unless @grid[row, col].revealed?
      end
    end
    true
  end

  def position_correct?(pos)
    row,col = pos
    row < @board_side_size && col < @board_side_size
  end

  def tile_revealed?(pos)
    row,col = pos 
    tile = @grid[row][col]
    if tile.hidden?
      tile.reveal
      return true
    end
    false
  end
  #TODO add check_adjacent_tiles proc that gets an array argument in the form
  #of [row,col] and checks if there is a bomb tile value in the 8 adjacent tiles

  #TODO add over? proc that check if the game is over or not

end
