module Rstatsd
  module Helpers
    def format_key(key)
      key.strip
        .gsub(/\s+/, '_')
        .gsub(/\//, '-')
        .gsub(/[^a-zA-Z_\-0-9\.]/, '')
    end
  end
end
