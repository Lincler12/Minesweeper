class Tile
  def initialize(value)
    @value = value
    @hidden = true
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

  def revealed?
    @hidden == false
  end

end
