Gem::Specification.new do |s|
  s.name        = 'logan'
  s.version     = '0.0.1'
  s.date        = '2013-07-17'
  s.summary     = "ruby gem to communicate with new Basecamp API"
  s.authors     = ["Stephen Birarda"]
  s.email       = 'logan@birarda.com'
  s.files       = ["lib/logan.rb"]
  s.files      += Dir.glob("lib/logan/*.rb")
  s.homepage    = 'http://rubygems.org/gems/logan'
end