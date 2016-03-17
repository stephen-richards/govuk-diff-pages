# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'govuk/diff/pages/version'

Gem::Specification.new do |spec|
  spec.name          = "govuk-diff-pages"
  spec.version       = Govuk::Diff::Pages::VERSION
  spec.authors       = ["Ben Lovell"]
  spec.email         = ["benjamin.lovell@gmail.com"]

  spec.summary       = 'Visual and textual page diffing.'
  spec.description   = 'Diffs web pages both visually and textually.'
  spec.homepage      = "https://github.com/alphagov/govuk-diff-pages"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "diffy", "~> 3.1"
  spec.add_dependency "rest-client", "~> 1.8"
  spec.add_dependency "nokogiri"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "gem_publisher", "~> 1.1"
end
