require 'logan/HashConstructed'

module Logan
  class Person
    include HashConstructed
    
    attr_accessor :id
    attr_accessor :name
  end  
end