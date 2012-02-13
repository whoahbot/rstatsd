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

      fields = bits.last.split("|")
      case fields[1]
      when 'c'
        if fields[0] == '1'
          @redis.incr(key).callback do |value|
            @redis.rpush("counter:#{key}", "#{value}:#{Time.now.to_i}")
          end
        elsif fields[0] == '-1'
          @redis.decr(key).callback do |value|
            @redis.rpush("counter:#{key}", "#{value}:#{Time.now.to_i}")
          end
        end
      when 'ms'
        #update timer
        @redis.rpush("timer:#{key}", "#{fields[0]}:#{Time.now.to_i}")
      else
        # invalid update
      end
    end

    def unbind
    end
  end
end
