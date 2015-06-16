require 'logan/HashConstructed'
require 'logan/response_handler'

module Logan
  class Person
    include HashConstructed
    include ResponseHandler

    attr_accessor :id
    attr_accessor :identity_id
    attr_accessor :name
    attr_accessor :email_address
    attr_accessor :admin
    attr_accessor :avatar_url
    attr_accessor :created_at
    attr_accessor :updated_at
    attr_accessor :url

    def to_hash
      { :id => @id, :type => "Person" }
    end

    def projects
      response = Logan::Client.get "/people/#{@id}/projects.json"
      handle_response(response, Proc.new {|h| Logan::Project.new(h) })
    end
  end
end