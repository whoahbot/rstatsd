require 'em-hiredis'
require 'eventmachine_httpserver'
require 'evma_httpserver/response'
require 'erb'

require_relative './helpers'

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
        chart = ERB.new(File.open('chart.erb').read).result(binding)

        response.content_type 'text/html'
        response.content = chart
        response.send_response
      when '/stats'
        key = format_key(@http_query_string)

        @redis.lrange("list:#{key}", 0, -1).callback {|datapoint|
          stats = datapoint.map do |point|
            val, time = point.split(":")
            [time, val.to_i]
          end
          response.content_type 'application/json'
          response.content = stats
          response.send_response
        }
      end
    end
  end
end
