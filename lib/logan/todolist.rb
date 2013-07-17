require 'logan/HashConstructed'

module Logan
  class TodoList
    include HashConstructed
    
    attr_accessor :id
    attr_accessor :name
    attr_accessor :description
    attr_accessor :completed
  end  
end