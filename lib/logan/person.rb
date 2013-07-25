require 'logan/HashConstructed'

module Logan
  class Person
    include HashConstructed
    
    attr_accessor :id
    attr_accessor :name
    
    def to_hash
      { :id => @id, :type => "Person" }
    end
  end  
end