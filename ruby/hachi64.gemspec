# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "hachi64"
  spec.version       = "0.1.0"
  spec.authors       = ["fengb3"]
  spec.email         = []

  spec.summary       = "哈吉米64 encoding and decoding"
  spec.description   = "Hachi64 provides encoding and decoding using a custom 64-character Chinese character set, similar to Base64 but with Hachimi-style characters."
  spec.homepage      = "https://github.com/fengb3/Hachi64"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/fengb3/Hachi64"

  spec.files = Dir["lib/**/*", "README.md"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "~> 3.12"
end
