require 'png'

module Rstatsd
  module Charts
    class Line
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def to_png
        canvas = PNG::Canvas.new 200, 200
        PNG.new(canvas).to_blob
      end
    end
  end
end
