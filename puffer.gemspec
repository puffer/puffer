# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "puffer"
  s.summary = "Insert Puffer summary."
  s.description = "Insert Puffer description."
  s.files = Dir["lib/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.version = "0.0.1"
end