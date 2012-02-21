require 'statsd'
require 'benchmark'

#      user     system      total        real
#  0.920000   1.900000   2.820000 (  3.579831)

s = Statsd.new('localhost')

Benchmark.bm do |x|
  x.report { 10000.times { s.increment('foobar') }}
end
