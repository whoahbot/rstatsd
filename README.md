# rstatsd

rstatsd is a ruby based daemon for capturing data from statsd clients.

rstatsd is inspired by the work at etsy to measure anything, measure
everything. They use a combination of node.js and graphite to capture
and graph this data.

The goal of this project was to replicate this approach in a very light-weight
way by reducing the number of dependencies to do this to two: redis and ruby.

## Installation

    $ gem install rstatsd

## Usage

Start redis

    $ brew install redis
    $ redis-server /usr/local/etc/redis.conf


Start the collection daemon and server

    $ rstatsd

Open the web server in a browser and follow the directions:

    $ open  http://localhost:8126/
