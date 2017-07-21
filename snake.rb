require 'curses'

class Field
  attr_reader :part, :area

  Curses.init_screen
  Curses.noecho

  begin
    
  ensure
    Curses.close_screen
  end
end

class Snake
    attr_reader :part, :size, :direction
end

class Apple
    attr_reader :part, :location
end
