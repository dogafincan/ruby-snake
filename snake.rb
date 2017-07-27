require 'curses'

class Field
  attr_reader :length, :width, :field_matrix

  def initialize(width, length)
    @length = length
    @width = width
    create_field
  end

  def create_field
    @field_matrix = Array.new(length) { Array.new(width, ' . ') }
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
