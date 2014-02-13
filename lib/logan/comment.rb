require 'logan/HashConstructed'

module Logan
  class Comment
    include HashConstructed
    
    attr_accessor :id
    attr_accessor :content
    attr_accessor :created_at
    attr_accessor :updated_at
    attr_reader :creator
    
    # sets the creator for this todo
    # 
    # @param [Object] creator person hash from API or <Logan::Person> object
    def creator=(creator)
      @creator = creator.is_a?(Hash) ? Logan::Person.new(creator) : creator        
    end
  end
end