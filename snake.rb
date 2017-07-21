require 'curses'

class Field
  # Remove unnecessary reader attributes.
  attr_reader :part, :width, :length, :area

  def initialize(width, length)
    @width = width
    @length = length
    @part = ' . '
    @area = Array.new(length) { Array.new(width, @part) }
  end

  def display
    field_string = ''
    @length.times do |line|
      @width.times do |column|
        field_string << @area[line][column]
      end
      field_string << "\n"
    end
    Curses.setpos(0, 0)
    Curses.addstr(field_string)
    Curses.refresh
  end

  def center_position
    horizontal_middle = width / 2
    vertical_middle = length / 2
    # Are the horizontal and vertical middles in the right order?
    Curses.setpos(horizontal_middle, vertical_middle)
  end

  def game_over
    center_position
    Curses.addstr('Game Over')
    Curses.refresh
    Curses.getch
  end
end

class Snake
  # Remove unnecessary reader attributes.
  attr_reader :part, :size, :direction

  def initialize
  end
end

class Apple
  # Remove unnecessary reader attributes.
  attr_reader :part, :location

  def initialize
  end
end

Curses.init_screen
Curses.noecho
Curses.curs_set(0)

begin
  field = Field.new(15, 15)
  while true
    field.display
  end
  # field.game_over
ensure
  Curses.close_screen
end
