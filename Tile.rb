class Tile
  def initialize(value)
    @value = value
    @hidden = true
    @flagged = false
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

end
