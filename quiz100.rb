require "rubygems"
require "awesome_print"

module Compiler
  class << self 
    def compile(expr)
      bytecode = []
      parse(expr) do |x, y, operation|
        bytecode << [x, y, operation].flatten
      end
      bytecode.flatten
    end

    def parse(expr)
      items = expr.split(%r{(\d*)\s*(\d*)}).reject(&:empty?)
      items.each_slice(3).each do |array|
        yield(to_code(array[0]), to_code(array[2]), to_code(array[1]))
      end
      expr
    end

    def to_code(str)
      case str
      when "+" then 10
      when "-" then 11
      when "*" then 12
      when "/" then 13
      else 
        digit = str.to_i
        to_long_const(digit)
      end
    end

    def to_long_const(digit)
      [2, 0, 0, 0, digit]
    end

    def to_small_const(digit)
      [1, 0, digit]
    end
  end
end
