require 'colorize'
class Tile
  attr_accessor :value, :neighbor_tiles, :selected, :flagged

  BOMB = 'b'

  def initialize
    @value = 0
    @hidden = true
    @flagged = false
    @neighbor_tiles = []
    @selected = false
  end

  def add_one_to_neighbor_tiles
    @neighbor_tiles.each { |tile| tile.add_one }
  end

  def add_neighbor_tiles(tile)
    @neighbor_tiles << tile
  end

  def neighbor_to_bomb?
    @value > 0
  end

  def hide
    @hidden = true
  end

  def add_one
    @value += 1 unless bomb?
  end

  def bomb?
    @value == BOMB
  end

  def place_bomb
    @value = BOMB
  end

  def reveal
    @hidden = false
  end

  def hidden?
    @hidden == true
  end

  def to_s
    return 'f'.colorize(:magenta) if @flagged && @hidden

    return '_'.colorize(:yellow) if @hidden && @selected

    return '*'.colorize(:white) if @hidden

    return @value.to_s.colorize(:red) if @value.is_a?(String) && @value == BOMB
    return @value.to_s.colorize(:green) if @value.is_a?(Integer) && @value > 0
    return @value.to_s.colorize(:light_blue)
  end
end
