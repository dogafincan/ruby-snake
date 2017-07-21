require 'curses'

class Field
  attr_reader :part, :width, :length

  def initialize(width, length)
    @width = width
    @length = length
    @part = ' . '
    @area = Array.new(length) { Array.new(width, @part) }
  end

  def center
    horizontal_middle = width / 2
    vertical_middle = length / 2
    Curses.setpos(horizontal_middle, horizontal_middle)
  end

  def game_over
    # Perhaps the centering should be moved
    # so it can be reused in other places.
    center
    Curses.addstr('Game Over')
    Curses.refresh
    Curses.getch
  end

end

class Snake
  attr_reader :part, :size, :direction

  def initialize
  end
end

class Apple
  attr_reader :part, :location

  def initialize
  end
end

Curses.init_screen
Curses.noecho
Curses.curs_set(0)

begin
  field = Field.new(15, 15)
  field.game_over
ensure
  Curses.close_screen
end
