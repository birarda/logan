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
    attr_accessor :url
    
    def initialize(h)
      @remaining_todos = []
      @completed_todos = []
      super
    end
    
    def post_json
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
        :body => todo.post_json,
        :headers => Logan::Client.headers.merge({'Content-Type' => 'application/json'})
      }
       
      response = Logan::Client.post "/projects/#{@project_id}/todolists/#{@id}/todos.json", post_params
      Logan::Todo.new response
    end
    
    def update_todo(todo)
      put_params = {
        :body => todo.put_json,
        :headers => Logan::Client.headers.merge({'Content-Type' => 'application/json'})
      }
             
      response = Logan::Client.put "/projects/#{@project_id}/todos/#{todo.id}.json", put_params
      Logan::Todo.new response
    end
    
    def delete_todo(todo)
      response = Logan::Client.delete "/projects/#{@project_id}/todos/#{todo.id}.json"
    end
  end  
end