require 'em-hiredis'

module Rstatsd
  class Collector < EventMachine::Connection
    def initialize
      super
      @redis = EM::Hiredis.connect
    end

    def post_init
    end

    def receive_data(data)
      bits = data.split(':')
      key = bits.shift.gsub(/\s+/, '_').gsub(/\//, '-').gsub(/[^a-zA-Z_\-0-9\.]/, '')
      @redis.incr(key).callback {|value|
        @redis.rpush("list:#{key}", "#{value}:#{Time.now.to_i}")
        puts "list:#{key}", "#{value}:#{Time.now.to_i}"
      }
      #bits.each do |bit|
      #  puts bit.split("|")
      #end
    end

    def unbind
    end
  end
end
