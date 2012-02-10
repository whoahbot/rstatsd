# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rstatsd/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Whoahbot!"]
  gem.email         = ["whoahbot@gmail.com"]
  gem.description   = %q{a stats daemon that stores data in redis}
  gem.summary       = %q{rstatsd is a ruby variation on statsd, without all the dependencies}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.bindir        = 'bin'
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "rstatsd"
  gem.require_paths = ["lib"]
  gem.version       = Rstatsd::VERSION

  gem.add_dependency "em-hiredis"
  gem.add_dependency "eventmachine"

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "statsd-ruby"
  gem.add_development_dependency 'em-spec', '~> 0.2.5'
end
