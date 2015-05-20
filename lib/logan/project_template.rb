require 'logan/HashConstructed'

module Logan
  class ProjectTemplate
    include HashConstructed

    attr_accessor :id
    attr_accessor :name


    # create a project based on this project template via Basecamp API
    #
    # @param [String] name name for the new project
    # @param [String] description description for the new project
    # @return [Logan::Project] project instance from Basecamp API response
    def create_project( name, description = nil)
      post_params = {
        :body => {name: name, description: description}.to_json,
        :headers => Logan::Client.headers.merge({'Content-Type' => 'application/json'})
      }

      response = Logan::Client.post "/project_templates/#{@id}/projects.json", post_params
      Logan::Project.new response
    end

  end
end
