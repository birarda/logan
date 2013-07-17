require 'logan/HashConstructed'

module Logan
  class TodoList
    include HashConstructed
    
    attr_accessor :id
    attr_accessor :name
    attr_accessor :description
    attr_accessor :completed
    
    def to_json
        { :name => @name, :description => @description }.to_json
    end
  end  
end