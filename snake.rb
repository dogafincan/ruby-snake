require 'curses'

class Field
  attr_reader :area

  Curses.init_screen
  Curses.noecho

  begin
    
  ensure
    Curses.close_screen
  end
end

class Snake
    attr_reader :size, :direction
end

class Apple
    attr_reader :location
end
