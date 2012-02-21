require 'redis'
require 'hiredis'

module Rstatsd
  module Helpers
    def format_key(key)
      key.strip
        .gsub(/\s+/, '_')
        .gsub(/\//, '-')
        .gsub(/[^a-zA-Z_\-0-9\.]/, '')
    end

    def counter_key_name(key)
      "counter:#{key}"
    end

    def timer_key_name(key)
      "timer:#{key}"
    end

    def redis
      @redis ||= Redis.new
    end

    def fetch_counters(counters)
      finished_data = {}
      counters.each_with_index do |counter, index|
        data = redis_data_for(counter)
        data.keys.each do |key|
          finished_data[key] ||= Array.new(counters.length, 0)
          finished_data[key][index] = data[key]
        end
      end
      finished_data
    end

    def redis_data_for(key)
      redis.lrange(counter_key_name(key), 0, -1).inject({}) do |memo, point|
        val, time = point.split(":")
        memo[time] = val.to_i
        memo
      end
    end
  end
end
