require 'curses'

class Field
    attr_reader :area
end

class Snake
    attr_reader :size, :direction
end

class Apple
    attr_reader :location
end
