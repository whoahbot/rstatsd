require File.expand_path('../lib/rstatsd', __FILE__)

EventMachine::run {
  EventMachine::open_datagram_socket("127.0.0.1", 8125, Rstatsd::Collector)
  EventMachine::start_server("127.0.0.1", 8126, Rstatsd::Server)
}
