require "rubygems"
require "awesome_print"

module Compiler
  CONST = 0x01
  LCONST = 0x02
  ADD = 0x0a
  SUB = 0x0b
  MUL = 0x0c
  POW = 0x0d
  DIV = 0x0e

  class << self 
    def compile(expr)
      bytecode = []
      parse(expr) do |x, y, operation|
        bytecode << [x, y, operation].flatten
      end
      bytecode.flatten
    end

    def parse(expr)
      items = expr.split(%r{(\d)\s*(\d*)}).reject(&:empty?)
      items.each_slice(3).each do |array|
        yield(to_code(array[0]), to_code(array[2]), to_code(array[1]))
      end
      expr
    end

    def to_code(str)
      case str
      when "+" then ADD
      when "-" then SUB
      when "*" then MUL
      when "/" then DIV
      when "**" then POW
      else 
        digit = str.to_i
        digit_to_bytes(digit)
      end
    end

    def digit_to_bytes(digit)
      bytes = []
      x_to_256(digit, bytes)
      array = bytes.reverse
      array.slice!(4, 10)
      if array.size > 2
        array.insert(0, 0) until array.size >= 4
        [LCONST, array].flatten
      else 
        array.insert(0, 0) until array.size >= 2
        [CONST, array].flatten
      end
    end

    def x_to_256(digit, bytes)
      if digit > 256
        bytes << 255
        x_to_256(digit/256, bytes)
      else
        bytes << digit
      end
    end
  end
end
