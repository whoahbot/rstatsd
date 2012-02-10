require 'spec_helper'

describe Rstatsd::Server do
  context "for a simple counter" do

    let(:replies) {
      {:lrange => ["12345678:1"]}
    }

    def connect_to_mock(url, &blk)
      redis_mock(replies) do
        connect(url, &blk)
      end
    end

    it "should return an array timestamps and values from the redis datastore" do
      connect_to_mock("redis://localhost:6380/") do |redis|
        rstatsd_server = Rstatsd::Server.new(stub)
        rstatsd_server.receive_data('espresso').should == ["12345678", 1]
      end
    end
  end
end
