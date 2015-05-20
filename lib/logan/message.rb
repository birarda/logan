require 'logan/HashConstructed'

module Logan
  class Message
    include HashConstructed

    attr_accessor :id
    attr_accessor :subject
    attr_accessor :content
    attr_accessor :private
    attr_accessor :trashed
    attr_accessor :subscribers
    attr_accessor :creator
    attr_accessor :comments
  end
end
