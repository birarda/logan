require 'logan/project'

module Logan
  class Client
    include HTTParty
    
    def initialize(basecamp_id, username, password, user_agent)
      self.class.base_uri "https://basecamp.com/#{basecamp_id}/api/v1"
      self.class.basic_auth username, password
      self.class.headers 'User-Agent' => user_agent
    end
    
    def projects
      response = self.class.get '/projects.json'
      response.parsed_response.map { |h| p = Logan::Project.new(h) }
    end
    
    def todolists
      response = self.class.get '/todolists.json'
      
      response.parsed_response.map do |h| 
        list = Logan::TodoList.new(h)
        
        # grab the project ID for this list from the url
        list.project_id = list.url.scan( /projects\/(\d+)/).last.first
        
        # return the list so this method returns an array of lists
        list
      end
    end
  end
end