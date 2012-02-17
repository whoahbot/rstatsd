require_relative '../lib/rstatsd'
require 'timecop'

RSpec.configure do |config|
end

def with_em_connection
  EM.run {
    yield
    EM.stop
  }
end
