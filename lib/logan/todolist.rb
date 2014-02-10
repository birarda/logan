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
    attr_accessor :remaining_count
    attr_accessor :completed_count
    attr_accessor :url
    attr_writer :remaining_todos
    attr_writer :completed_todos
    
    # intializes a todo list by calling the HashConstructed initialize method and 
    # setting both @remaining_todos and @completed_todos to empty arrays
    def initialize(h)
      @remaining_todos = []
      @completed_todos = []
      super
    end
    
    def post_json
        { :name => @name, :description => @description }.to_json
    end
    
    # refreshes the data for this todo list from the API
    def refresh
      response = Logan::Client.get "/projects/#{@project_id}/todolists/#{@id}.json"
      initialize(response.parsed_response)
    end
    
    # returns the array of remaining todos - potentially synchronously downloaded from API
    #  
    # @return [Array<Logan::Todo>] Array of remaining todos for this todo list
    def remaining_todos
      if @remaining_todos.empty? && @remaining_count > 0
        refresh
      end
      
      return @remaining_todos
    end
    
    # returns the array of completed todos - potentially synchronously downloaded from API
    #  
    # @return [Array<Logan::Todo>] Array of completed todos for this todo list
    def completed_todos
      if @completed_todos.empty? && @completed_count > 0
        refresh
      end
      
      return @completed_todos
    end
    
    # returns an array of all todos, completed and remaining - potentially synchronously downloaded from API
    #  
    # @return [Array<Logan::Todo>] Array of completed todos for this todo list
    def todos
      remaining_todos + completed_todos
    end
    
    # assigns the {#remaining_todos} and {#completed_todos} from the associated keys
    # in the passed hash
    # 
    # @param [Hash] todo_hash hash possibly containing todos under 'remaining' and 'completed' keys
    def todos=(todo_hash)
      @remaining_todos = todo_hash['remaining'].map { |h| Logan::Todo.new h }
      @completed_todos = todo_hash['completed'].map { |h| Logan::Todo.new h }
      return nil
    end
    
    # searches the remaining and completed todos for the first todo with the substring in its content
    # 
    # @param [String] substring substring to look for
    # @return [Logan::Todo] the matched todo, or nil if there wasn't one
    def todo_with_substring(substring)      
      issue_todo = @remaining_todos.detect{ |t| !t.content.index(substring).nil? }
      issue_todo ||= @completed_todos.detect { |t| !t.content.index(substring).nil? }
    end
    
    # create a todo in this todo list via the Basecamp API
    # 
    # @param [Logan::Todo] todo the todo instance to create in this todo lost
    # @return [Logan::Todo] the created todo returned from the Basecamp API
    def create_todo(todo)
      post_params = {
        :body => todo.post_json,
        :headers => Logan::Client.headers.merge({'Content-Type' => 'application/json'})
      }
       
      response = Logan::Client.post "/projects/#{@project_id}/todolists/#{@id}/todos.json", post_params
      Logan::Todo.new response
    end
    
    # update a todo in this todo list via the Basecamp API
    # 
    # @param [Logan::Todo] todo the todo instance to update in this todo list
    # @return [Logan::Todo] the updated todo instance returned from the Basecamp API
    def update_todo(todo)
      put_params = {
        :body => todo.put_json,
        :headers => Logan::Client.headers.merge({'Content-Type' => 'application/json'})
      }
             
      response = Logan::Client.put "/projects/#{@project_id}/todos/#{todo.id}.json", put_params
      Logan::Todo.new response
    end
    
    # delete a todo in this todo list via delete call to Basecamp API
    # 
    # @param [Logan::Todo] todo the todo instance to be delete from this todo list
    # @return [HTTParty::response] response from Basecamp for delete request
    def delete_todo(todo)
      response = Logan::Client.delete "/projects/#{@project_id}/todos/#{todo.id}.json"
    end
  end  
end