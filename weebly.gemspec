# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'weebly/version'

Gem::Specification.new do |spec|
  spec.name          = "weebly"
  spec.version       = Weebly::VERSION
  spec.authors       = ["Joshua Beitler"]
  spec.email         = ["joshbeitler@gmail.com"]
  spec.summary       = %q{Makes weebly development easier}
  spec.description   = %q{Makes weebly development easier}
  spec.homepage      = "https://github.com/joshbeitler/weebly"
  spec.license       = "Apache-2.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency "commander"
  spec.add_runtime_dependency "rubyzip"
  spec.add_runtime_dependency "colorize"
  
end
