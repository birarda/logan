require 'logan/HashConstructed'

module Logan
  class Project
    include HashConstructed
    
    attr_accessor :id
    attr_accessor :name
  end  
end