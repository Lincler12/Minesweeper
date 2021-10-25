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


  def unselect_tile(tile)
    tile.selected = false
  end

  def generate_bombs
    @number_of_bombs.times do
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
    @grid = Array.new(@board_side_size) { Array.new(@board_side_size) { Tile.new } }
    find_tile_neighbors
    @bomb_positions.each { |row, col| @grid[row][col].place_bomb }
    place_numbered_tiles
  end

  def find_tile_neighbors
    @board_side_size.times do |row|
      @board_side_size.times do |col|
        if row == 0
          if col == 0
            @grid[row][col].add_neighbor_tiles(@grid[row][col + 1])
            @grid[row][col].add_neighbor_tiles(@grid[row + 1][col])
            @grid[row][col].add_neighbor_tiles(@grid[row + 1][col + 1])
          elsif col == @board_side_size - 1
            @grid[row][col].add_neighbor_tiles(@grid[row][col - 1])
            @grid[row][col].add_neighbor_tiles(@grid[row + 1][col - 1])
            @grid[row][col].add_neighbor_tiles(@grid[row + 1][col])
          else
            @grid[row][col].add_neighbor_tiles(@grid[row][col - 1])
            @grid[row][col].add_neighbor_tiles(@grid[row][col + 1])
            @grid[row][col].add_neighbor_tiles(@grid[row + 1][col - 1])
            @grid[row][col].add_neighbor_tiles(@grid[row + 1][col])
            @grid[row][col].add_neighbor_tiles(@grid[row + 1][col + 1])
          end
        elsif row == @board_side_size - 1
          if col == 0
            @grid[row][col].add_neighbor_tiles(@grid[row - 1][col])
            @grid[row][col].add_neighbor_tiles(@grid[row - 1][col + 1])
            @grid[row][col].add_neighbor_tiles(@grid[row][col + 1])
          elsif col == @board_side_size - 1
            @grid[row][col].add_neighbor_tiles(@grid[row - 1][col - 1])
            @grid[row][col].add_neighbor_tiles(@grid[row - 1][col])
            @grid[row][col].add_neighbor_tiles(@grid[row][col - 1])
          else
            @grid[row][col].add_neighbor_tiles(@grid[row - 1][col - 1])
            @grid[row][col].add_neighbor_tiles(@grid[row - 1][col])
            @grid[row][col].add_neighbor_tiles(@grid[row - 1][col + 1])
            @grid[row][col].add_neighbor_tiles(@grid[row][col - 1])
            @grid[row][col].add_neighbor_tiles(@grid[row][col + 1])
          end
        elsif col == 0
          @grid[row][col].add_neighbor_tiles(@grid[row - 1][col])
          @grid[row][col].add_neighbor_tiles(@grid[row - 1][col + 1])
          @grid[row][col].add_neighbor_tiles(@grid[row][col + 1])
          @grid[row][col].add_neighbor_tiles(@grid[row + 1][col])
          @grid[row][col].add_neighbor_tiles(@grid[row + 1][col + 1])
        elsif col == @board_side_size - 1
          @grid[row][col].add_neighbor_tiles(@grid[row - 1][col - 1])
          @grid[row][col].add_neighbor_tiles(@grid[row - 1][col])
          @grid[row][col].add_neighbor_tiles(@grid[row][col - 1])
          @grid[row][col].add_neighbor_tiles(@grid[row + 1][col - 1])
          @grid[row][col].add_neighbor_tiles(@grid[row + 1][col])
        else
          @grid[row][col].add_neighbor_tiles(@grid[row - 1][col - 1])
          @grid[row][col].add_neighbor_tiles(@grid[row - 1][col])
          @grid[row][col].add_neighbor_tiles(@grid[row - 1][col + 1])
          @grid[row][col].add_neighbor_tiles(@grid[row][col - 1])
          @grid[row][col].add_neighbor_tiles(@grid[row][col + 1])
          @grid[row][col].add_neighbor_tiles(@grid[row + 1][col - 1])
          @grid[row][col].add_neighbor_tiles(@grid[row + 1][col])
          @grid[row][col].add_neighbor_tiles(@grid[row + 1][col + 1])
        end
      end
    end
  end

  def place_numbered_tiles
    @bomb_positions.each do |row, col|
      @grid[row][col].add_one_to_neighbor_tiles
    end
  end

  def tile_has_bomb?(tile)
    tile.bomb?
  end

  # Win condition: Each tile is revealed other than the ones with bomb
  def win?
    @board_side_size.times do |row|
      @board_side_size.times do |col|
        next if @bomb_positions.include?([row, col])
        return false if @grid[row][col].hidden?
      end
    end
    true
  end

  def reveal_neighbor_tiles(tile)
    return unless tile.hidden?

    return if tile.bomb?

    if tile.neighbor_to_bomb?
      tile.reveal
      return
    end

    tile.reveal
    tile.neighbor_tiles.each do |neighbor_tile|
      reveal_neighbor_tiles(neighbor_tile)
    end
  end

  def position_correct?(pos)
    row, col = pos
    row < @board_side_size && row >= 0 && row.is_a?(Integer) && col < @board_side_size && col >= 0 && col.is_a?(Integer)
  end

  def tile_reveal(tile)
    tile.reveal
  end

  def render
    puts "------"
    @board_side_size.times do |row|
      @board_side_size.times do |col|
        print @grid[row][col]
      end
      print "\n"
    end
    puts "------"
  end

  def selected_tile?(tile)
    tile.selected = true if tile.hidden?
    tile.selected
  end

  def flag_tile(tile)
    tile.flagged = !tile.flagged
  end
end

if __FILE__ == $PROGRAM_NAME
  board = Board.new(9, 9)
  board.init_grid
  board.render
  puts board.win?
end
