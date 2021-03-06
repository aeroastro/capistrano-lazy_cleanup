
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "capistrano/lazy_cleanup/version"

Gem::Specification.new do |spec|
  spec.name          = "capistrano-lazy_cleanup"
  spec.version       = Capistrano::LazyCleanup::VERSION
  spec.authors       = ["Takumasa Ochi"]
  spec.email         = ["aeroastro007@gmail.com"]

  spec.summary       = %q{Capistrano plugin for faster deployment.}
  spec.description   = %q{This gem makes deployment faster by offloading cleanup I/O for Capistrano 3.x (and 3.x only).}
  spec.homepage      = "https://github.com/aeroastro/capistrano-lazy_cleanup"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "capistrano", "~> 3.1"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
