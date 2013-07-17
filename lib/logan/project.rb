require 'logan/HashConstructed'
require 'logan/todolist'

module Logan
  class Project
    include HashConstructed
    
    attr_accessor :id
    attr_accessor :name
    
    def todolists
      active_response = Logan::Client.get "/projects/#{@id}/todolists.json"
      lists_array = active_response.parsed_response.map do |h| 
        Logan::TodoList.new h.merge({ :project_id => @id })
      end
    end
    
    def completed_todolists
      completed_response = Logan::Client.get "/projects/#{@id}/todolists/completed.json"
      lists_array = completed_response.parsed_response.map do |h| 
        Logan::TodoList.new h.merge({ :project_id => @id })
      end
    end
    
    def all_todolists
      todolists + completed_todolists
    end
    
    def todolist(list_id)
      response = Logan::Client.get "/projects/#{@id}/todolists/#{list_id}.json"
      Logan::TodoList.new response.parsed_response.merge({ :project_id => @id })
    end
    
    def create_todolist(todolist)
      post_params = {
        :body => todolist.post_json,
        :headers => Logan::Client.headers.merge({'Content-Type' => 'application/json'})
      }
          
      response = Logan::Client.post "/projects/#{@id}/todolists.json", post_params
      Logan::TodoList.new response.merge({ :project_id => @id })
    end
  end  
end