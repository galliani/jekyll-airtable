
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jekyll-airtable/version"

Gem::Specification.new do |spec|
  spec.name          = "jekyll-airtable"
  spec.version       = Jekyll::Airtable::VERSION
  spec.authors       = ["Galih Muhammad"]
  spec.email         = ["galih0muhammad@gmail.com"]

  spec.summary       = "Jekyll plugin to integrate Airtable"
  spec.description   = "Airtable support in Jekyll site to easily fetch and store data"
  spec.homepage      =  "https://github.com/galliani/jekyll-airtable"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.3.0"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "dotenv"
  spec.add_dependency 'faraday', '~> 0.11.0'
  spec.add_dependency 'faraday_middleware', '~>  0.10.1'
  spec.add_dependency "jekyll", "~> 3.3"  
end
