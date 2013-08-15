Gem::Specification.new do |s|
  s.name = %q{puppy}
  s.version = '1.0.1'
  s.license = "BSD"

  s.authors = ["Simone Margaritelli"]
  s.description = %q{Puppy is a tiny gem to perform easy object tracing and debugging.}
  s.email = %q{evilsocket@gmail.com}
  s.files = Dir.glob("lib/**/*") + [
     "LICENSE",
     "README.md",
     "Rakefile",
     "Gemfile",
     "puppy.gemspec"
  ]
  s.homepage = %q{http://github.com/evilsocket/puppy}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.summary = %q{Puppy is a tiny gem to perform easy object tracing and debugging.}
end


