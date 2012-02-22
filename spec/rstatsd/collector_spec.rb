require 'spec_helper'

describe Rstatsd::Collector do
  let(:redis) {
    stub.as_null_object
  }

  before do
    Redis.stub(:new).and_return(redis)
  end

  context "receiving an increment packet 'crumdingler:1|c'" do
    it "should increment the counter stored at the keyname" do
      with_em_connection do
        redis.should_receive(:incr).with('crumdingler').and_return(stub.as_null_object)
        Rstatsd::Collector.new(stub).receive_data('crumdingler:1|c')
      end
    end

    it "should rpush the counter value into redis" do
      with_em_connection do
        Timecop.freeze(Time.now) do
          redis.should_receive(:incr).with('crumdingler').and_return('1')
          redis.should_receive(:rpush).
            with('counter:crumdingler', "1:#{Time.now.to_i}").
              and_return(stub.as_null_object)
          Rstatsd::Collector.new(stub).receive_data('crumdingler:1|c')
        end
      end
    end

    it "should trim the overall size of the counter list to 10000 entries" do
      with_em_connection do
        redis.should_receive(:ltrim).with('counter:crumdingler', -10000, -1)
        Rstatsd::Collector.new(stub).receive_data('crumdingler:1|c')
      end
    end

    it "should rpush the incremented value onto a list in the format counter:keyname" do
      with_em_connection do
        redis.stub(:incr)
        redis.should_receive(:rpush).with('counter:crumdingler', anything)
        Rstatsd::Collector.new(stub).receive_data('crumdingler:1|c')
      end
    end

    context "with a sample rate" do
    end
  end

  context "decrementing a value" do
    it "should decrement the counter stored at the keyname" do
      with_em_connection do
        redis.should_receive(:decr).with('crumdingler')
        Rstatsd::Collector.new(stub).receive_data('crumdingler:-1|c')
      end
    end

    it "should rpush the returned counter value into redis" do
      with_em_connection do
        Timecop.freeze(Time.now) do
          redis.stub(:decr).and_return('-1')
          redis.should_receive(:rpush).
            with('counter:crumdingler', "-1:#{Time.now.to_i}")
          Rstatsd::Collector.new(stub).receive_data('crumdingler:-1|c')
        end
      end
    end

    it "should trim the overall size of the counter list to 10000 entries" do
      with_em_connection do
        redis.should_receive(:ltrim).with('counter:crumdingler', -10000, -1)
        Rstatsd::Collector.new(stub).receive_data('crumdingler:-1|c')
      end
    end
  end
end
