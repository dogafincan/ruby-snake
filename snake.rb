require 'curses'

class Field
  attr_reader :part, :area

  def initialize
  end

  Curses.init_screen
  Curses.noecho

  begin
    
  ensure
    Curses.close_screen
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
