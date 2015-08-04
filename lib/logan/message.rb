require 'logan/HashConstructed'

module Logan
  class Message
    include HashConstructed

    attr_accessor :id
    attr_accessor :project_id
    attr_accessor :subject
    attr_accessor :content
    attr_accessor :private
    attr_accessor :trashed
    attr_accessor :subscribers
    attr_accessor :creator
    
    def initialize h
      super

      unless app_url.nil? || app_url.blank?
        @project_id ||= app_url[/projects\/(\d*)\//, 1].to_i
      end

      self
    end 
    
    # returns the array of comments - potentially synchronously downloaded from API
    #
    # @return [Array<Logan::Comment] Array of comments on this todo
    def comments
      refresh if (@comments.nil? || @comments.empty?) && @comments_count > 0
      @comments ||= Array.new
    end
    
    # assigns the {#comments} from the passed array
    #
    # @param [Array<Object>] comment_array array of hash comments from API or <Logan::Comment> objects
    # @return [Array<Logan::Comment>] array of comments for this todo
    def comments=(comment_array)
      @comments = comment_array.map { |obj| obj = Logan::Comment.new obj if obj.is_a?(Hash) }
    end
    
    # create a create in this todo list via the Basecamp API
    #
    # @param [Logan::Comment] todo the comment instance to create in this todo lost
    # @return [Logan::Comment] the created comment returned from the Basecamp API
    def create_comment(comment)
      post_params = {
        :body => comment.post_json,
        :headers => Logan::Client.headers.merge({'Content-Type' => 'application/json'})
      }

      response = Logan::Client.post "/projects/#{@project_id}/messages/#{@id}/comments.json", post_params
      Logan::Comment.new response
    end
  end
end
