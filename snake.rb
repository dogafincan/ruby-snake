require 'curses'

# The field class is responsible for creating a field matrix
# which can be used by other classes to add snake and apple
# objects.
class Field
  attr_reader :length, :width, :field_matrix

  def initialize(width, length)
    @length = length
    @width = width
    create_field
  end

  # The create_field method creates a two-dimensional array. One
  # comprising the rows of the field matrix, and the other the columns.
  def create_field
    @field_matrix = Array.new(length) { Array.new(width, ' . ') }
  end
end

# The snake class is responsible for creating snake objects
# and for implementing the movements of those objects within the
# field matrix.
class Snake
  attr_reader :size, :direction, :location, :snake_matrix

  def initialize(field_width)
    @size = 4
    @direction = :left
    # The snake starts at the top right corner of the field.
    @location = [0, field_width]
    create_snake
  end

  # The create_snake method creates a two-dimensional array. The inner array
  # consists of the horizontal and vertical location of each snake part.
  def create_snake
    vertical_position = location[0]
    horizontal_position = location[1]
    @snake_matrix = Array.new(size) { |part_index| [vertical_position, horizontal_position + part_index] }
  end

  # The head of the snake is always the first array of the snake matrix.
  def locate_head
    snake_matrix.first
  end

  def head_vertical_location
    locate_head.first
  end

  def head_horizontal_location
    locate_head.last
  end

  # The body consists of all the arrays in the snake matrix except the first one.
  def locate_body
    snake_matrix[1..-1]
  end

  def increase_size
    @size += 1
    snake_matrix << snake_matrix.last
  end

  # Inputs a new vertical location for the head of the snake in order
  # to simulate vertical movement.
  def update_head_vertical_location(row)
    locate_head[0] = row
  end

  # Inputs a new horizontal location for the head of the snake in order
  # to simulate horizontal movement.
  def update_head_horizontal_location(column)
    locate_head[1] = column
  end

  def change_direction
    user_input = Curses.getch
    case user_input
    when Curses::KEY_UP
      @direction = :up
    when Curses::KEY_DOWN
      @direction = :down
    when Curses::KEY_LEFT
      @direction = :left
    when Curses::KEY_RIGHT
      @direction = :right
    end
  end

  def move_one_frame
    new_head_vertical_location = head_vertical_location
    new_head_horizontal_location = head_horizontal_location

    case direction
    when :left
      new_head_horizontal_location -= 1
    when :right
      new_head_horizontal_location += 1
    when :up
      new_head_vertical_location -= 1
    when :down
      new_head_vertical_location += 1
    end

    # This is the part that I've struggled with the most. The two method
    # calls below first add a new array to the snake matrix: the one that
    # consists of the new location of the head. The second method call
    # removes the last array of the snake matrix. Combining the two simulates
    # the movement of the snake.
    snake_matrix.unshift([new_head_vertical_location, new_head_horizontal_location])
    snake_matrix.pop
  end
end

# The apple class creates an apple object and gives
# that object its coordinates within the field matrix.
class Apple
  attr_reader :horizontal_location, :vertical_location

  def initialize(field_width, field_height)
    @horizontal_location = Random.rand(field_width - 1)
    @vertical_location = Random.rand(field_height - 1)
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
