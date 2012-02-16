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
  end
end
