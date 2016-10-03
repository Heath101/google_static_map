# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'google_static_map_signature/version'

Gem::Specification.new do |spec|
  spec.name          = "google_static_map_signature"
  spec.version       = GoogleStaticMapSignature::VERSION
  spec.authors       = ["Heath Attig"]
  spec.email         = ["heath.attig@gmail.com"]

  spec.summary       = %q{Google Static Map API digital signature algorithm}
  spec.description   = %q{When using Google Maps Premium Plan all calls to the static maps api require the inclusion of your client id and a digital signature.  This small gem implements Google's digital signing algorithm}
  spec.homepage      =  "https://github.com/Heath101/google_static_map_signature"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
