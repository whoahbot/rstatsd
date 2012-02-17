require 'spec_helper'

describe Rstatsd::Collector do
  let(:hiredis) {
    stub.as_null_object
  }

  let(:redis_result) {
    redis_result = stub
  }

  before do
    EM::Hiredis.stub(:connect).and_return(hiredis)
  end

  context "receiving an increment packet 'crumdingler:1|c'" do
    it "should increment the counter stored at the keyname" do
      with_em_connection do
        hiredis.should_receive(:incr).with('crumdingler').and_return(stub.as_null_object)
        Rstatsd::Collector.new(stub).receive_data('crumdingler:1|c')
      end
    end

    it "should rpush the counter value into redis" do
      with_em_connection do
        Timecop.freeze(Time.now) do
          hiredis.should_receive(:incr).with('crumdingler').and_return(redis_result)
          redis_result.should_receive(:callback).and_yield('1')
          hiredis.should_receive(:rpush).with('counter:crumdingler', "1:#{Time.now.to_i}").and_return(stub.as_null_object)
          Rstatsd::Collector.new(stub).receive_data('crumdingler:1|c')
        end
      end
    end

    it "should trim the overall size of the counter list to 10000 entries" do
      with_em_connection do
        hiredis.should_receive(:ltrim).with('counter:crumdingler', 10000)
        Rstatsd::Collector.new(stub).receive_data('crumdingler:1|c')
      end
    end

    it "should rpush the incremented value onto a list in the format counter:keyname" do
      with_em_connection do
        redis_result.should_receive(:callback).and_yield('1')
        hiredis.stub(:incr).and_return(redis_result)

        hiredis.should_receive(:rpush).with('counter:crumdingler', anything)
        Rstatsd::Collector.new(stub).receive_data('crumdingler:1|c')
      end
    end

    context "with a sample rate" do
    end
  end

  context "decrementing a value" do
    it "should decrement the counter stored at the keyname" do
      with_em_connection do
        hiredis.should_receive(:incr).with('crumdingler').and_return(stub.as_null_object)
        Rstatsd::Collector.new(stub).receive_data('crumdingler:1|c')
      end
    end

    it "should rpush the returned counter value into redis" do
      with_em_connection do
        Timecop.freeze(Time.now) do
          hiredis.should_receive(:decr).with('crumdingler').and_return(redis_result)
          redis_result.should_receive(:callback).and_yield('-1')
          hiredis.should_receive(:rpush).with('counter:crumdingler', "-1:#{Time.now.to_i}").and_return(stub.as_null_object)
          Rstatsd::Collector.new(stub).receive_data('crumdingler:-1|c')
        end
      end
    end

    it "should trim the overall size of the counter list to 10000 entries" do
      with_em_connection do
        hiredis.should_receive(:ltrim).with('counter:crumdingler', 10000)
        Rstatsd::Collector.new(stub).receive_data('crumdingler:-1|c')
      end
    end
  end
end
