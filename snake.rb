require 'curses'

# Split up classes into seperate files.
class Field

  attr_reader :apple, :width, :length

  def initialize(width, length)
    @width = width
    @length = length
    @field_matrix = Array.new(length) { Array.new(width, ' . ') }
    @apple = Apple.new
  end

  # Write matrix_to_string method to decrease size of print.
  def print
    @apple.add(15, 15)

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
    horizontal_middle = @width / 2
    vertical_middle = @length / 2
    # Are the horizontal and vertical middles in the right order?
    Curses.setpos(vertical_middle, horizontal_middle)
  end

  # move this method to game class?
  def game_over
    set_center
    Curses.addstr('Game Over')
    Curses.refresh
    # What does this getch function do exactly?
    Curses.getch
  end
end

class Snake
  def initialize
    @direction = 'right'
    @location = Array.new(4) { |snake_part| [0, snake_part] }
  end

  def change_direction
  end

  def move
  end
end

class Apple
  def initialize
  end

  def add(length, width)
    loop do
      vertical_location = rand(length)
      horizontal_location = rand(width)
      field.field_matrix[vertical_location][horizontal_location] = ' o '
    end
  end
end

class Game
end

# Should the code below be in a Game class?
Curses.init_screen

begin
  Curses.stdscr.keypad = true
  Curses.noecho
  Curses.curs_set(0)
  Curses.timeout = 0
  field = Field.new(15, 15)

  loop do
    field.print
    sleep(0.1)

    user_input = Curses.getch
    case user_input
    when Curses::KEY_UP
      snake.move_up
    when Curses::KEY_DOWN
      snake.move_down
    when Curses::KEY_LEFT
      snake.move_left
    when Curses::KEY_RIGHT
      snake.move_right
    end
  end
  # field.game_over
ensure
  Curses.close_screen
end
