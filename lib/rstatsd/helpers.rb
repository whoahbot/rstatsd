require 'em-hiredis'

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

    def fetch_counter(key)
      redis = EM::Hiredis.connect
      redis.lrange(counter_key_name(key), 0, -1).callback do |datapoint|
        stats = datapoint.map do |point|
          val, time = point.split(":")
          [val.to_i, time]
        end
        yield stats
      end
    end
  end
end
