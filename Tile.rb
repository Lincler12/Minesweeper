class Tile
  attr_accessor :value, :neighbor_tiles

  BOMB = 'b'

  def initialize
    @value = 0
    @hidden = false
    @flagged = false
    @neighbor_tiles = []
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
    return 'f' if @flagged

    return '*' if @hidden

    @value.to_s
  end
end
