Gem::Specification.new do |s|
  s.name        = 'logan'
  s.version     = '0.0.4'
  s.date        = Time.now
  s.summary     = "ruby gem to communicate with new Basecamp API"
  s.authors     = ["Stephen Birarda"]
  s.email       = 'logan@birarda.com'
  s.files       = ["lib/logan.rb"]
  s.files      += Dir.glob("lib/logan/*.rb")
  s.homepage    = 'https://github.com/birarda/logan'
  s.license     = 'MIT'
end