require 'json'

module Rstatsd
  class Chart
    include Rstatsd::Helpers

    attr_accessor :data

    def initialize(query_string)
      @query_string = query_string
      @data = []
    end

    def targets
      @query_string.split("&").map do |term|
        param_name, value = term.split("=")
        value if param_name == 'target'
      end
    end

    def column_types
      targets.inject([]) do |memo, target|
        memo << ['datetime', 'Timestamp']
        memo << ['number', target.capitalize]
        memo
      end
    end

    def title
      @query_string.split("&").detect do |term|
        param_name, value = term.split("=")
        if param_name == 'title'
          return URI.unescape(value)
        end
      end
      targets.map(&:capitalize).join(', ')
    end

    def chart_binding
      binding
    end

    def draw_chart
      targets.each do |target|
        fetch_counter(target) do |data|
          @data << data
          yield self
        end
      end
    end

    def width
      800
    end

    def height
      480
    end
  end
end
