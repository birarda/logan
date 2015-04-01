require 'logan/HashConstructed'
require 'logan/comment'
require 'logan/person'

module Logan
  class Todo
    include HashConstructed

    attr_accessor :id
    attr_accessor :project_id
    attr_accessor :content
    attr_accessor :completed
    attr_accessor :comments_count
    attr_reader :assignee
    attr_accessor :due_at
    attr_accessor :position
    attr_accessor :app_url
    attr_accessor :url
    attr_accessor :trashed
    attr_accessor :private

    def initialize h
      super
      @project_id ||= app_url[/projects\/(\d*)\//, 1].to_i unless app_url.blank?
    end

    def post_json
      {
        :content => @content,
        :due_at => @due_at,
        :assignee => @assignee.nil? ? nil : @assignee.to_hash
      }.to_json
    end

    def put_json
      {
        :content => @content,
        :due_at => @due_at,
        :assignee => @assignee.nil? ? nil : @assignee.to_hash,
        :position => (@position.nil? || @position.to_s.empty?) ? 99  : @position,
        :completed => @completed
      }.to_json
    end

    def save
      put_params = {
        :body => put_json,
        :headers => Logan::Client.headers.merge({'Content-Type' => 'application/json'})
      }

      response = Logan::Client.put url, put_params
      Logan::Todo.new response
    end

    # refreshes the data for this todo from the API
    def refresh
      response = Logan::Client.get "/projects/#{project_id}/todos/#{id}.json"
      initialize(response.parsed_response)
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

    # sets the assignee for this todo
    #
    # @param [Object] assignee person hash from API or <Logan::Person> object
    # @return [Logan::Person] the assignee for this todo
    def assignee=(assignee)
      @assignee = assignee.is_a?(Hash) ? Logan::Person.new(assignee) : assignee
    end
  end
end
