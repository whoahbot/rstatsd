require 'spec_helper'

describe Rstatsd::Helpers do
  include Rstatsd::Helpers

  describe "#format_key" do
    it "should make underscores into spaces" do
      format_key('snozz berries').should == 'snozz_berries'
    end

    it "should make slashes into dashes" do
      format_key('snozz/berries').should == 'snozz-berries'
    end

    it "should remove non alphanumeric chars" do
      format_key('@snozzberries').should == 'snozzberries'
    end
  end

  describe "#counter_key_name" do
    it "should return counter:key_name" do
      counter_key_name('frobozz').should == 'counter:frobozz'
    end
  end

  describe "fetching data from redis" do
    let(:redis) {
      stub.as_null_object
    }

    let(:redis_result) {
      redis_result = stub
    }

    before do
      Redis.stub(:new).and_return(redis)
    end

    describe "#redis_data_for" do
      it "should fetch all of the values from redis" do
        redis.should_receive(:lrange).with('counter:crumdingler', 0, -1).
          and_return(['1:1234567'])
        redis_data_for('crumdingler')
      end

      it "should split the data into value, time pairs" do
        redis.stub(:lrange => ['1:1234567'])
        redis_data_for('crumdingler').should == {'1234567' => 1}
      end
    end

    describe "#fetch_counters" do
      it "should split the data into value, time pairs" do
        redis.stub(:lrange => ['1:1234567'])
        fetch_counters(['crumdingler', 'zardoz']).
          should == {'1234567' => [1, 1]}
      end

      it "should fill in 0 when there is no data from one of the targets" do
        redis.stub(:lrange).and_return(['1:1234567'], [])
        fetch_counters(['crumdingler', 'zardoz']).
          should == {'1234567' => [1, 0]}
      end
    end
  end
end
