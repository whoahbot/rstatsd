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
      counters.inject({}) do |memo, counter|
        data = redis_data_for(counter)
        memo.merge(data) {|key, old, new| [old, new].flatten}
      end
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
