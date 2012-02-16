module Rstatsd
  attr_accessor :configuration
  
  def self.configure
    configuration ||= Configuration.new()
    yield(configuration)
    @configuration = configuration
  end

  class Configuration
    attr_accessor :redis_db, :redis_host

    def initialize
      @redis_db = 1
      @redis_host = '127.0.0.1:6379'
    end

    def [](option)
      send(option)
    end
  end
end
    
