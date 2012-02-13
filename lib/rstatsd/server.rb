require 'em-hiredis'
require 'eventmachine_httpserver'
require 'evma_httpserver/response'
require 'erb'

require_relative './helpers'
require_relative './charts'

module Rstatsd
  class Server < EventMachine::Connection
    include EventMachine::HttpServer
    include Rstatsd::Helpers

    def post_init
      super
      @redis = EM::Hiredis.connect
    end

    def process_http_request
      response = EM::DelegatedHttpResponse.new(self)

      case @http_request_uri
      when '/'
        chart = ERB.new(File.open('google_chart.erb').read).result(binding)

        response.content_type 'text/html'
        response.content = chart
        response.send_response
      when '/stats.json'
        key = format_key(@http_query_string)

        @redis.lrange("counter:#{key}", 0, -1).callback {|datapoint|
          stats = datapoint.map do |point|
            val, time = point.split(":")
            [val.to_i, time]
          end
          response.content_type 'application/json'
          response.content = stats
          response.send_response
        }
      when '/stats.png'
        key = format_key(@http_query_string)
        @redis.lrange("counter:#{key}", 0, -1).callback {|data|
          chart = Rstatsd::Charts::Line.new(data).process

          response.content_type 'image/png'
          response.content = chart.png.to_blob
          response.send_response
        }
      end
    end
  end
end
