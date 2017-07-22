require 'curses'

class Field
  # Remove unnecessary reader attributes.
  attr_reader :width, :length, :field_matrix

  def initialize(width, length)
    @width = width
    @length = length
    @field_matrix = Array.new(length) { Array.new(width, ' . ') }
  end

  def print
    field_string = ''
    @length.times do |line|
      @width.times do |column|
        field_string << @field_matrix[line][column]
      end
      field_string << "\n"
    end
    Curses.setpos(0, 0)
    Curses.addstr(field_string)
    Curses.refresh
  end

  def set_center
    horizontal_middle = width / 2
    vertical_middle = length / 2
    # Are the horizontal and vertical middles in the right order?
    Curses.setpos(vertical_middle, horizontal_middle)
  end

  def game_over
    set_center
    Curses.addstr('Game Over')
    Curses.refresh
    # What does this getch function do exactly?
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

# Should the code below be in a Game class?
Curses.init_screen
Curses.noecho
Curses.curs_set(0)

begin
  field = Field.new(15, 15)
  while true
    field.print
  end
  # field.game_over
ensure
  Curses.close_screen
end
