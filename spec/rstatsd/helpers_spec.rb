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

  describe "#fetch_counter" do
    let(:hiredis) {
      stub.as_null_object
    }

    let(:redis_result) {
      redis_result = stub
    }

    before do
      EM::Hiredis.stub(:connect).and_return(hiredis)
    end

    it "should fetch all of the values from redis" do
      with_em_connection do
        hiredis.should_receive(:lrange).with('counter:crumdingler', 0, -1).and_return(redis_result)
        redis_result.should_receive(:callback).and_yield(['1:1234567'])
        fetch_counter('crumdingler') do |stats|
          stats.should == [[1, '1234567']]
        end
      end
    end
  end
end
