require 'spec_helper'

describe Rstatsd::Server do
  context "for a simple counter" do
    module Client
      def post_init
        send_data('espresso')
        close_connection_after_writing
      end
    end

    it "should return an array timestamps and values from the redis datastore" do
      redis_mock do
        #redis.lpush('espresso', "12345678:1")
        EM.run {
          EventMachine::start_server("127.0.0.1", 8126, Rstatsd::Server)
          EM.connect("127.0.0.1", 9999, Client)
          EM.stop
        }
      end
    end
  end
end
