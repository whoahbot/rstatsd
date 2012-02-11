require 'em-hiredis'
require 'eventmachine_httpserver'
require 'evma_httpserver/response'

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
        response.content_type 'text/html'
        response.content = File.read('demo.html')
        response.send_response
      when '/stats'
        data = 'test'
        key = format_key(data)

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
