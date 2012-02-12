require 'em-hiredis'
require_relative './helpers'

module Rstatsd
  class Collector < EventMachine::Connection
    include Rstatsd::Helpers

    def initialize
      super
      @redis = EM::Hiredis.connect
    end

    def post_init
    end

    def receive_data(data)
      bits = data.split(':')
      key = format_key(bits.first)

      @redis.incr(key).callback {|value|
        @redis.rpush("list:#{key}", "#{value}:#{Time.now.to_i}")
      }
    end


    def unbind
    end
  end
end
