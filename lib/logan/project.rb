require 'logan/HashConstructed'
require 'logan/todolist'
require 'logan/response_handler'

module Logan
  class Project
    include HashConstructed
    include ResponseHandler

    attr_accessor :id
    attr_accessor :name
    attr_accessor :description
    attr_accessor :updated_at
    attr_accessor :url
    attr_accessor :app_url
    attr_accessor :template
    attr_accessor :archived
    attr_accessor :starred
    attr_accessor :trashed
    attr_accessor :draft
    attr_accessor :is_client_project
    attr_accessor :color

    # get active todo lists for this project from Basecamp API
    #
    # @return [Array<Logan::TodoList>] array of active todo lists for this project
    def todolists
      active_response = Logan::Client.get "/projects/#{@id}/todolists.json"
      lists_array = active_response.parsed_response.map do |h|
        Logan::TodoList.new h.merge({ :project_id => @id })
      end
    end

    # publish this project from Basecamp API
    #
    # @return <Logan::Project> this project
    def publish
      post_params = {
        :body => {}.to_json,
        :headers => Logan::Client.headers.merge({'Content-Type' => 'application/json'})
      }

      response = Logan::Client.post "/projects/#{@id}/publish.json", post_params
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

    def add_client_by_id(id)
      post_params = {
        :body => { ids: [id] }.to_json,
        :headers => Logan::Client.headers.merge({'Content-Type' => 'application/json'})
      }

      response = Logan::Client.post "/projects/#{@id}/client_accesses.json", post_params
    end

    def add_user_by_email(email)
      post_params = {
        :body => { email_addresses: [email] }.to_json,
        :headers => Logan::Client.headers.merge({'Content-Type' => 'application/json'})
      }

      response = Logan::Client.post "/projects/#{@id}/accesses.json", post_params
    end

    def add_client_by_email(email)
      post_params = {
        :body => { email_addresses: [email] }.to_json,
        :headers => Logan::Client.headers.merge({'Content-Type' => 'application/json'})
      }

      response = Logan::Client.post "/projects/#{@id}/client_accesses.json", post_params
    end

    # create a message via Basecamp API
    #
    # @param [String] subject subject for the new message
    # @param [String] content content for the new message
    # @param [Array] subscribers array of subscriber ids for the new message
    # @param [Bool] private should the private flag be set for the new message
    # @return [Logan::Message] message instance from Basecamp API response
    def create_message(subject, content, subscribers, private)
      post_params = {
        :body => {subject: subject, content: content, subscribers: subscribers, private: private}.to_json,
        :headers => Logan::Client.headers.merge({'Content-Type' => 'application/json'})
      }

      response = Logan::Client.post "/projects/#{@id}/messages.json", post_params
      Logan::Message.new response
    end


    # returns the array of remaining todos - potentially synchronously downloaded from API
    #
    # @return [Array<Logan::Todo>] Array of remaining todos for this todo list
    def remaining_todos &block
      return @remaining_todos if @remaining_todos
      remaining_todos! &block
    end

    def remaining_todos! &block
      @remaining_todos = []
      if block_given?
        page = 1
        while true

          response = Logan::Client.get "/projects/#{@id}/todos/remaining.json?page=#{page}"
          list = handle_response(response, Proc.new {|h| Logan::Todo.new(h.merge({ :project_id => @id })) })
          @remaining_todos << list
          page += 1
          break if list.size < 50
        end
        @remaining_todos = @remaining_todos.flatten
      else
        response = Logan::Client.get "/projects/#{@id}/todos/remaining.json"
        @remaining_todos = handle_response(response, Proc.new {|h| Logan::Todo.new(h.merge({ :project_id => @id })) })
      end
      @remaining_todos
    end

    # returns the array of completed todos - potentially synchronously downloaded from API
    #
    # @return [Array<Logan::Todo>] Array of completed todos for this todo list
    def completed_todos
      return @completed_todos if @completed_todos
      completed_todos!
    end

    def completed_todos!
      response = Logan::Client.get "/projects/#{@id}/todos/completed.json"

      @completed_todos = handle_response(response, Proc.new {|h| Logan::Todo.new(h.merge({ :project_id => @id })) })
    end

    # returns the array of trashed todos - potentially synchronously downloaded from API
    #
    # @return [Array<Logan::Todo>] Array of trashed todos for this todo list
    def trashed_todos
      return @trashed_todos if @trashed_todos
      trashed_todos!
    end

    def trashed_todos!
      response = Logan::Client.get "/projects/#{@id}/todos/trashed.json"

      @trashed_todos = handle_response(response, Proc.new {|h| Logan::Todo.new(h.merge({ :project_id => @id })) })
    end

    # returns the array of todos - potentially synchronously downloaded from API
    #
    # @return [Array<Logan::Todo>] Array of todos for this todo list
    def todos
      return @todos if @todos
      todos!
    end

    def todos!
      response = Logan::Client.get "/projects/#{@id}/todos.json"

      @todos = handle_response(response, Proc.new {|h| Logan::Todo.new(h.merge({ :project_id => @id })) })
    end


  end
end