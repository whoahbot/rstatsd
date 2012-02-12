require_relative '../../lib/rstatsd'

describe Rstatsd::Collector do
  let!(:hiredis) {
    EM::Hiredis = stub.as_null_object 
  }

  def with_em_connection
    EM.run {
      yield
      EM.stop
    }
  end

  context "receiving an increment packet 'foobar:1|c'" do
    it "should increment the counter stored at the keyname" do
      with_em_connection do
        hiredis.should_receive(:incr).with('foobar').and_return(stub.as_null_object)
        Rstatsd::Collector.new(stub).receive_data('foobar:1|c')
      end
    end

    let(:redis_result) {
      redis_result = mock
    }

    it "should rpush the incremented value onto a list in the format counter:keyname" do
      with_em_connection do
        redis_result.should_receive(:callback).and_yield('1')
        hiredis.stub(:incr).and_return(redis_result)

        hiredis.should_receive(:rpush).with('counter:foobar', anything)
        Rstatsd::Collector.new(stub).receive_data('foobar:1|c')
      end
    end

    context "with a sample rate" do
    end
  end

  context "decrementing a value" do
    it "should decrement the counter stored at the keyname" do
      #'foobar:-1|c'
    end
  end
end
