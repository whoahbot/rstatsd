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
    end

    def process_http_request
      response = EM::DelegatedHttpResponse.new(self)

      case @http_request_uri
      when '/'
        Rstatsd::Chart.new(@http_query_string).draw_chart do |chart|
          @chart = chart
          google_chart = ERB.new(File.open('google_chart.erb').read).result(binding)

          response.content_type 'text/html'
          response.content = google_chart
          response.send_response
        end
      when '/stats.json'
        key = format_key(@http_query_string)
        Rstatsd::Chart.new(@http_query_string)

        response.content_type 'application/json'
        response.content = @chart.data
        response.send_response
      end
    end
  end
end
