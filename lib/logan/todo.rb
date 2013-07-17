require 'logan/HashConstructed'
require 'logan/person'

module Logan
  class Todo
    include HashConstructed
    
    attr_accessor :id
    attr_accessor :content
    attr_accessor :completed
    attr_accessor :assignee
    
    def assignee=(assignee)
      @assignee = Logan::Person.new assignee
    end
  end  
end