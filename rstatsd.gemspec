# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rstatsd/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Whoahbot!"]
  gem.email         = ["whoahbot@gmail.com"]
  gem.description   = %q{a stats daemon that stores data in redis}
  gem.summary       = %q{rstatsd is a simpler ruby implementaiton of statsd, storing the data in redis}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.bindir        = 'bin'
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "rstatsd"
  gem.require_paths = ["lib"]
  gem.version       = Rstatsd::VERSION

  gem.add_dependency "redis"
  gem.add_dependency "hiredis"
  gem.add_dependency "eventmachine"
  gem.add_dependency "eventmachine_httpserver"

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "timecop"
  gem.add_development_dependency "statsd-ruby"
end
