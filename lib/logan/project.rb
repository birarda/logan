require 'logan/HashConstructed'
require 'logan/todolist'

module Logan
  class Project
    include HashConstructed
    
    attr_accessor :id
    attr_accessor :name
    
    # get active todo lists for this project from Basecamp API
    # 
    # @return [Array<Logan::TodoList>] array of active todo lists for this project
    def todolists
      active_response = Logan::Client.get "/projects/#{@id}/todolists.json"
      lists_array = active_response.parsed_response.map do |h| 
        Logan::TodoList.new h.merge({ :project_id => @id })
      end
    end
    
    # get completed todo lists for this project from Basecamp API
    # 
    # @return [Array<Logan::TodoList>] array of completed todo lists for this project
    def completed_todolists
      completed_response = Logan::Client.get "/projects/#{@id}/todolists/completed.json"
      lists_array = completed_response.parsed_response.map do |h| 
        Logan::TodoList.new h.merge({ :project_id => @id })
      end
    end
    
    # get both active and completed todo lists for this project from Basecamp API
    # 
    # @return [Array<Logan::TodoList>] array of active and completed todo lists for this project
    def all_todolists
      todolists + completed_todolists
    end
    
    # get an individual todo list for this project from Basecamp API
    # 
    # @param [String] list_id id for the todo list
    # @return [Logan::TodoList] todo list instance
    def todolist(list_id)
      response = Logan::Client.get "/projects/#{@id}/todolists/#{list_id}.json"
      Logan::TodoList.new response.parsed_response.merge({ :project_id => @id })
    end
    
    # create a todo list in this project via Basecamp API
    # 
    # @param [Logan::TodoList] todo_list todo list instance to be created
    # @return [Logan::TodoList] todo list instance from Basecamp API response
    def create_todolist(todo_list)
      post_params = {
        :body => todo_list.post_json,
        :headers => Logan::Client.headers.merge({'Content-Type' => 'application/json'})
      }
          
      response = Logan::Client.post "/projects/#{@id}/todolists.json", post_params
      Logan::TodoList.new response.merge({ :project_id => @id })
    end

    def accesses
      response = Logan::Client.get "/projects/#{@id}/accesses.json"
      response.parsed_response.map { |h| p = Logan::Person.new(h) }
    end

    def add_user_by_id(id)
      post_params = {
        :body => { ids: [id] }.to_json,
        :headers => Logan::Client.headers.merge({'Content-Type' => 'application/json'})
      }

      response = Logan::Client.post "/projects/#{@id}/accesses.json", post_params
    end
  end  
end