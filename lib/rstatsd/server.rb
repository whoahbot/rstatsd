require 'em-hiredis'
require 'eventmachine_httpserver'
require 'evma_httpserver/response'
require 'erb'

require_relative './helpers'
require_relative './chart'

module Rstatsd
  class Server < EventMachine::Connection
    include EventMachine::HttpServer
    include Rstatsd::Helpers

    def post_init
      super
      @redis = EM::Hiredis.connect
    end
    
    def fetch_counter(key)
      @redis.lrange("counter:#{key}", 0, -1).callback {|datapoint|
        stats = datapoint.map do |point|
          val, time = point.split(":")
          [val.to_i, time]
        end
        yield stats
      }
    end

    def process_http_request
      response = EM::DelegatedHttpResponse.new(self)

      case @http_request_uri
      when '/'
        key = format_key(@http_query_string)

        fetch_counter(key) do |stats|
          @chart = Rstatsd::Chart.new(
            :column_types => [['datetime', 'Timestamp'],
                              ['number', 'Grebulons consumed']],
            :title => 'Real-time graph of grebulons consumed in M13 cluster',
            :data => stats
          )

          chart = ERB.new(File.open('google_chart.erb').read).result(binding)

          response.content_type 'text/html'
          response.content = chart
          response.send_response
        end
      when '/stats.json'
        key = format_key(@http_query_string)

        fetch_counter(key) do |stats|
          response.content_type 'application/json'
          response.content = stats
          response.send_response
        end
      end
    end
  end
end
