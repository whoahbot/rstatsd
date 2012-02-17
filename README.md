# rstatsd

rstatsd is a ruby based daemon for capturing data from statsd clients.

rstatsd is inspired by the work at etsy to measure everything, measure
anything. They use a combination of node.js and graphite to capture and
graph this data.

The goal of this project was to replicate this light-weight approach and
reduce the number of dependencies to do this to two: redis and ruby.

## Installation

    $ gem install rstatsd

## Usage

Start redis

    $ brew install redis
    $ redis-server /usr/local/etc/redis.conf


Start the collection daemon and server

    $ rstatsd

Add some data (you'll need a statsd compatible client like statsd-ruby)

    $ irb
    irb> require 'statsd'
    => true
    irb> s = Statsd.new('localhost')
    => #<Statsd:0x007fee419866d8 @host="localhost", @port=8125>
    irb(main):004:0> s.increment('grebulons')
    => 10
    irb> s.increment('grebulons')
    => 10
    irb> s.increment('grebulons')
    => 10
    irb> s.increment('grebulons')
    => 10


Then view the result in a web browser

    irb> `open  http://localhost:8126/?target=grebulons`

Bask in the something of something-something.
