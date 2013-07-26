require 'logan/HashConstructed'

module Logan
  class Event
    include HashConstructed
    
    attr_accessor :id
    attr_accessor :summary
    attr_accessor :url
  end  
end