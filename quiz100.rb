require "rubygems"
require "awesome_print"

module Compiler
  class << self 
    def compile(expr)
      bytecode = []
      parse(expr) do |x, y, operation|
        bytecode << [x, y, operation]
      end
      bytecode
    end

    def parse(expr)
      items = expr.split(%r{(\d*)\s*(\d*)}).reject(&:empty?)
      items.each_slice(3).each do |array|
        yield(array[0], array[2], array[1])
      end
      expr
    end
  end
end


ap Compiler.compile('3+2')
