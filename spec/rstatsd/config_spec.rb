require 'spec_helper'

describe Rstatsd::Configuration do
  describe "configuration properties" do
    context "with the defaults" do
      before do
        @config = Rstatsd::Configuration.new
      end

      it "should configure the redis db" do
        @config.redis_db.should == 1
      end

      it "should configure the redis hostname" do
        @config.redis_host.should == '127.0.0.1:6379'
      end
    end
  end
end
