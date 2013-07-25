require 'logan/project'

module Logan
  class Client
    include HTTParty
    
    # Initializes the Logan shared client with information required to communicate with Basecamp
    #
    # @param basecamp_id [String] the Basecamp company ID
    # @param username [String] the username to use for requests
    # @param password [String] the password to use for the passed username
    # @param user_agent [String] the user-agent string to include in header of requests
    def initialize(basecamp_id, username, password, user_agent)
      self.class.base_uri "https://basecamp.com/#{basecamp_id}/api/v1"
      self.class.basic_auth username, password
      self.class.headers 'User-Agent' => user_agent
    end
    
    # get projects from Basecamp API
    # 
    # @return [Array<Logan::Project>] array of {Logan::Project} instances
    def projects
      response = self.class.get '/projects.json'
      response.parsed_response.map { |h| p = Logan::Project.new(h) }
    end
    
    # get active Todo lists for all projects from Basecamp API
    # 
    # @return [Array<Logan::TodoList>] array of {Logan::TodoList} instances
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