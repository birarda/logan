require 'logan/HashConstructed'
require 'logan/person'

module Logan
  class Todo
    include HashConstructed
    
    attr_accessor :id
    attr_accessor :content
    attr_accessor :completed
    attr_accessor :assignee
    attr_accessor :due_at
    
    def post_json
      {
        :content => @content,
        :due_at => @due_at,
        :assignee => @assignee.to_hash
      }.to_json
    end
    
    def put_json
      { 
        :content => @content, 
        :due_at => @due_at,
        :assignee => @assignee.to_hash,
        :completed => @completed
      }.to_json
    end
    
    def assignee=(assignee)
      @assignee = assignee.is_a?(Hash) ? Logan::Person.new(assignee) : assignee        
    end
  end  
end