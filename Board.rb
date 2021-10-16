require 'byebug'
require_relative './Tile'
class Board
  attr_reader :grid

  BOARD_SIDE_SIZE = 3

  def initialize(number_of_bombs)
    @number_of_bombs = number_of_bombs
    @bomb_positions = []
    generate_bombs
    init_grid
  end

  def generate_bombs
    number_of_bombs.times do
      loop do
        row = rand(BOARD_SIDE_SIZE)
        col = rand(BOARD_SIDE_SIZE)
        next if @bomb_positions.include?([row, col])

        @bomb_positions << [row, col]
        break
      end
    end
  end

  def init_grid
    @grid = Array.new(BOARD_SIDE_SIZE) { Array.new(BOARD_SIDE_SIZE) { Tile.new('empty') } }

    @bomb_positions.each { |row, col| @grid[row][col].insert_bomb }
  end

  # Win condition: If each tile is revealed other than the ones with bomb
  def win?
    BOARD_SIDE_SIZE.times do |row|
      BOARD_SIDE_SIZE.times do |col|
        next if @bomb_positions.include?([row, col])
        return false unless @grid[row, col].revealed?
      end
    end
    true
  end

end
