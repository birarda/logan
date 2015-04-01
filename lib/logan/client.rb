require 'logan/project'
require 'logan/response_handler'
module Logan
  class Client
    include HTTParty
    include ResponseHandler

    # Initializes the Logan shared client with information required to communicate with Basecamp
    #
    # @param basecamp_id [String] the Basecamp company ID
    # @param auth_hash [Hash] authorization hash consisting of a username and password combination (:username, :password) or an access_token (:access_token)
    # @param user_agent [String] the user-agent string to include in header of requests
    def initialize(basecamp_id, auth_hash, user_agent)
      self.class.base_uri "https://basecamp.com/#{basecamp_id}/api/v1"
      self.class.headers 'User-Agent' => user_agent
      self.auth = auth_hash
    end

    # Updates authorization information for Logan shared client
    #
    # @param auth_hash [Hash] authorization hash consisting of a username and password combination (:username, :password) or an access_token (:access_token)
    def auth=(auth_hash)
      # symbolize the keys
      new_auth_hash = {}
      auth_hash.each {|k, v| new_auth_hash[k.to_sym] = v}
      auth_hash = new_auth_hash

      if auth_hash.has_key? :access_token
        # clear the basic_auth, if it's set
        self.class.default_options.reject!{ |k| k == :basic_auth }

        # set the Authorization headers
        self.class.headers.merge!("Authorization" => "Bearer #{auth_hash[:access_token]}")
      elsif auth_hash.has_key?(:username) && auth_hash.has_key?(:password)
        self.class.basic_auth auth_hash[:username], auth_hash[:password]

        # remove the access_token from the headers, if it exists
        self.class.headers.reject!{ |k, v| k == "Authorization" }
      else
        raise """
        Incomplete authorization information passed in authorization hash.
        You must have either an :access_token or a username password combination (:username, :password).
        """
      end
    end

    # get projects from Basecamp API
    #
    # @return [Array<Logan::Project>] array of {Logan::Project} instances
    def projects( id = nil)
      if id
        project_by_id id
      else
        all_projects
      end
    end

    # get project templatess from Basecamp API
    #
    # @return [Array<Logan::ProjectTemplate>] array of {Logan::ProjectTemplate} instances
    def project_templates
      response = self.class.get '/project_templates.json'
      handle_response(response, Proc.new {|h| Logan::ProjectTemplate.new(h) })
    end

    # get active Todo lists for all projects from Basecamp API
    #
    # @return [Array<Logan::TodoList>] array of {Logan::TodoList} instances
    def todolists
      response = self.class.get '/todolists.json'
      handle_response(response,
        Proc.new { |h|
          list = Logan::TodoList.new(h)

          # grab the project ID for this list from the url
          list.project_id = list.url.scan( /projects\/(\d+)/).last.first

          # return the list so this method returns an array of lists
          list
        }
      )
    end

    def events(since_time, page = 1)
      response = self.class.get "/events.json?since=#{URI.escape since_time.to_formatted_s(:iso8601)}&page=#{page}"
      handle_response(response, Proc.new {|h| Logan::Event.new(h) })
    end

    def people
      response = self.class.get "/people.json"
      handle_response(response, Proc.new {|h| Logan::Person.new(h) })
    end

    private
    def all_projects
      response = self.class.get '/projects.json'
      handle_response(response, Proc.new {|h| Logan::Project.new(h) })
    end

    def project_by_id id
      response = self.class.get  "/projects/#{id}.json"
      project = Logan::Project.new response
      project.json_raw = response.body
      project
    end
  end
end
