require_relative 'server'
require_relative 'collector'

EventMachine::run {
  EventMachine::open_datagram_socket("127.0.0.1", 8125, Rstatsd::Collector)
  EventMachine::start_server("127.0.0.1", 8126, Rstatsd::Server)
  puts "http server running at http://localhost:8126/"
  puts "go there for more instructions"
}
