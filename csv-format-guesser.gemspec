# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "csv-format-guesser"
  spec.version       = '0.0.2'
  spec.authors       = ["Eugen Martin"]
  spec.email         = ["eugenius martinus ad gmail"]
  spec.description   = %q{Guess format and encoding of .csv/.tsv files to generate options compatible with ruby CSV class. Works with ruby2.0 }
  spec.summary       = %q{CSV Format guesser for ruby. Uses rchardet.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "olgen-rchardet"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec", "~> 2.14"
end
