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
      response.parsed_response.map { |p| p = Logan::Project.new(p) }
    end
  end
end