require_relative '../lib/rstatsd'

require 'em-spec/rspec'

require 'support/connection_helper'
require 'support/redis_mock'
require 'stringio'

RSpec.configure do |config|
  config.include ConnectionHelper
  config.include EventMachine::SpecHelper
  config.include RedisMock::Helper
end
