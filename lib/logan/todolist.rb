require 'logan/HashConstructed'
require 'logan/todo'

module Logan
  class TodoList
    include HashConstructed
    
    attr_accessor :id
    attr_accessor :project_id
    attr_accessor :name
    attr_accessor :description
    attr_accessor :completed
    attr_accessor :remaining_todos
    attr_accessor :completed_todos
    
    def initialize(h)
      @remaining_todos = []
      @completed_todos = []
      super
    end
    
    def to_json
        { :name => @name, :description => @description }.to_json
    end
    
    def todos=(todo_hash)
      @remaining_todos = todo_hash['remaining'].map { |h| Logan::Todo.new h }
      @completed_todos = todo_hash['completed'].map { |h| Logan::Todo.new h }
    end
    
    def todo_with_substring(substring)      
      issue_todo = @remaining_todos.detect{ |t| !t.content.index(substring).nil? }
      issue_todo ||= @completed_todos.detect { |t| !t.content.index(substring).nil? }
    end
    
    def create_todo(todo)
      post_params = {
        :body => todo.to_json,
        :headers => Logan::Client.headers.merge({'Content-Type' => 'application/json'})
      }
       
      response = Logan::Client.post "/projects/#{@project_id}/todolists/#{@id}/todos.json", post_params
      Logan::Todo.new response
    end
  end  
end