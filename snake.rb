require 'curses'

class Field
  attr_reader :part, :area

  def initialize
    
  end

  def game_over
    x = Curses.cols / 2
    y = Curses.lines / 2
    Curses.setpos(y, x)
    Curses.addstr('Game Over')
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
Curses.cbreak

begin
  field = Field.new
  field.game_over
ensure
  Curses.close_screen
end
