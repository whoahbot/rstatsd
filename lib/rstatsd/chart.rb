require 'json'

module Rstatsd
  class Chart
    def initialize(options = {})
      @options = options
    end

    def column_types
      @options[:column_types]
    end

    def data
      JSON.dump(@options[:data])
    end

    def title
      @options[:title] || "Chart"
    end

    def width
      @options[:width] || 800
    end

    def height
      @options[:height] || 480
    end
  end
end
