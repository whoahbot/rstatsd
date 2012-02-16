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
            @redis.rpush(counter_key_name(key), "#{value}:#{Time.now.to_i}")
          end
        elsif fields[0] == '-1'
          @redis.decr(key).callback do |value|
            @redis.rpush(counter_key_name(key), "#{value}:#{Time.now.to_i}")
          end
        end
        @redis.ltrim(counter_key_name(key), 10000)
      when 'ms'
        #update timer
        @redis.rpush(timer_key_name(key), "#{fields[0]}:#{Time.now.to_i}")
        @redis.ltrim(timer_key_name(key), 10000)
      else
        # invalid update
      end
    end

    def unbind
    end
  end
end
