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
          canvas.line x, y, x, y + (val.to_i * 10), PNG::Color::Blue
          x = x + 10
        end

        @png = PNG.new(canvas)
        return self
      end
    end
  end
end
