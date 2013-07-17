require 'logan/HashConstructed'
require 'logan/person'

module Logan
  class Todo
    include HashConstructed
    
    attr_accessor :id
    attr_accessor :content
    attr_accessor :completed
    attr_accessor :assignee
    
    def to_json
      {
        :content => @content,
        :assignee => @assignee.to_hash
      }.to_json
    end
    
    def assignee=(assignee)
      @assignee = assignee.is_a?(Hash) ? Logan::Person.new(assignee) : assignee        
    end
  end  
end