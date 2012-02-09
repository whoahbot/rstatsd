require 'em-hiredis'

module Rstatsd
  class Server < EventMachine::Connection
    def initialize
      super
      @redis = EM::Hiredis.connect
    end

    def post_init
    end

    def receive_data(data)
      key = data.strip.gsub(/\s+/, '_').gsub(/\//, '-').gsub(/[^a-zA-Z_\-0-9\.]/, '')
      @redis.lrange("list:#{key}", 0, -1).callback {|datapoint|
        stats = datapoint.map do |point|
          val, time = point.split(":")
          [time, val.to_i]
        end
        send_data stats
      }
    end

    def unbind
    end
  end
end
