require 'curses'

# The field class is responsible for creating a field matrix
# which can be used by other classes to add snake and apple
# objects.
class Field
  attr_reader :length, :width, :field_matrix

  def initialize(width, length)
    @length = length
    @width = width
    create_empty_field
  end

  # The create_empty_field method creates a two-dimensional array. One
  # comprising the rows of the field matrix, and the other the columns.
  def create_empty_field
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
      @direction = :up if direction != :down
    when Curses::KEY_DOWN
      @direction = :down if direction != :up
    when Curses::KEY_LEFT
      @direction = :left if direction != :right
    when Curses::KEY_RIGHT
      @direction = :right if direction != :left
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

# The game class prints the start and end screen of
# the game, and animates the gameplay itself. It also
# checks certain conditions that decide the location of
# the snake and apple objects.
class Game
  attr_reader :field, :snake, :apple

  def initialize
    @field = Field.new(15, 15)
    @snake = Snake.new(field.width)
    @apple = Apple.new(field.width, field.length)
  end

  def print_field
    # Empty string variable looks ugly. Try to find a more
    # elegant solution.
    field_string = ''
    field.length.times do |line|
      field.width.times do |column|
        field_string << field.field_matrix[line][column]
      end
      field_string << "\n"
    end

    Curses.setpos(0, 0)
    Curses.addstr(field_string)
    Curses.refresh
  end

  # The print_filled_field method first creates an empty field and then
  # adds a snake matrix and an apple to that empty field matrix and
  # prints the result.
  def print_filled_field
    field.create_empty_field

    # Add an apple to the field.
    field.field_matrix[apple.vertical_location][apple.horizontal_location] = ' o '

    # Add a snake to the field.
    snake.snake_matrix.each do |part|
      field.field_matrix[part.first][part.last] = ' x '
    end

    print_field
  end

  def print_start_screen
    start_screen_string =

      "    ___   ____ ____    ____              _              \n"\
      "   / _ \\ / ___|  _ \\  / ___| _ __   __ _| | _____     \n"\
      "  | | | | |  _| | | | \\___ \\| '_ \\ / _` | |/ / _ \\  \n"\
      "  | |_| | |_| | |_| |  ___) | | | | (_| |   <  __/      \n"\
      "   \\___/ \\____|____/  |____/|_| |_|\\__,_|_|\\_\\___| \n"\
      "                                                        \n"\
      '             Press [s] to start game                      '

    loop do
      Curses.curs_set(0)
      Curses.noecho
      Curses.setpos(0, 0)
      Curses.addstr(start_screen_string)

      user_input = Curses.getch
      # include capital 's' in case of accidental caps lock.
      if user_input == 's'
        Curses.close_screen
        break
      end
    end
  end

  def print_end_screen
    Curses.close_screen
    end_screen_string =
      "   ____                         ___                          \n"\
      "  / ___| __ _ _ __ ___   ___   / _ \\__   _____ _ __         \n"\
      " | |  _ / _` | '_ ` _ \\ / _ \\ | | | \\ \\ / / _ \\ '__|    \n"\
      " | |_| | (_| | | | | | |  __/ | |_| |\\ V /  __/ |           \n"\
      "  \\____|\\__,_|_| |_| |_|\\___|  \\___/  \\_/ \\___|_|      \n"\
      "                                                             \n"\
      '             Press [e] to exit game                            '

    loop do
      Curses.curs_set(0)
      Curses.noecho
      Curses.setpos(0, 0)
      Curses.addstr(end_screen_string)

      user_input = Curses.getch
      # include capital 'e' in case of accidental caps lock.
      exit if user_input == 'e'
    end
  end

  def check_game_conditions
    snake_touches_field_edge
    snake_eats_apple
    snake_touches_own_body
  end

  def snake_touches_field_edge
    snake_touches_right_edge = snake.head_horizontal_location > field.width - 1
    snake_touches_left_edge = snake.head_horizontal_location < 0
    snake_touches_bottom_edge = snake.head_vertical_location  > field.length - 1
    snake_touches_top_edge = snake.head_vertical_location < 0

    snake.update_head_horizontal_location(0) if snake_touches_right_edge
    snake.update_head_horizontal_location(field.width - 1) if snake_touches_left_edge
    snake.update_head_vertical_location(0) if snake_touches_bottom_edge
    snake.update_head_vertical_location(field.length - 1) if snake_touches_top_edge
  end

  def snake_eats_apple
    snake_apple_vertical_touch = snake.head_vertical_location == apple.vertical_location
    snake_apple_horizontal_touch = snake.head_horizontal_location == apple.horizontal_location
    snake_apple_same_location = snake_apple_vertical_touch && snake_apple_horizontal_touch

    return unless snake_apple_same_location
    snake.increase_size
    # fix bug that makes apples appear within the body of the snake.
    @apple = Apple.new(field.width, field.length)
  end

  def snake_touches_own_body
    print_end_screen if snake.locate_body.include? snake.locate_head
  end

  # The animate_game method prints the filled field first, then it allows the
  # user to change the snake's direction, then moves the snake one frame,
  # and finally checks for conditions that change the circumstances of the game.
  # All of this is done repeatedly until the game ends.
  def animate_game
    begin
      Curses.stdscr.keypad = true
      Curses.noecho
      Curses.curs_set(0)
      Curses.timeout = 0

      loop do
        print_filled_field
        # Add a sleep method with a value of 0.1 to prevent the snake from
        # moving too fast. Adjust the value of sleep to speed up or slow down
        # the game.
        sleep(0.1)
        snake.change_direction
        snake.move_one_frame
        check_game_conditions
      end

    ensure
      Curses.close_screen
    end

    print_end_screen
  end

  def start
    print_start_screen
    animate_game
  end
end

game = Game.new
game.start
