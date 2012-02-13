require 'png'

module Rstatsd
  module Charts
    class Line
      attr_reader :data, :png

      def initialize(data)
        @data = data
      end

      def process
        canvas = PNG::Canvas.new 400, 300
        x = 50
        y = 50

        @data.each do |point|
          val, time = point.split(":")
          new_x = x + val.to_i
          new_y = y + 1
          canvas.line x, y, new_x, new_y, PNG::Color::Blue
          x = new_x
          y = new_y
        end

        @png = PNG.new(canvas)
        return self
      end
    end
  end
end
