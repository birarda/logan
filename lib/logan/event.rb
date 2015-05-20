require 'logan/HashConstructed'

module Logan
  class Event
    include HashConstructed
    include ResponseHandler

    attr_accessor :id
    attr_accessor :summary
    attr_accessor :url
    attr_accessor :eventable
    attr_accessor :updated_at
    attr_accessor :created_at
    attr_accessor :action
    attr_accessor :summary
    attr_accessor :raw_excerpt
    attr_accessor :excerpt


    def eventable= h
      @eventable = OpenStruct.new h
    end

    def get
      begin
        response = Logan::Client.get eventable.url
        o = "Logan::#{eventable.type}".constantize.new response.parsed_response
        o.json_raw = response.body
        o
      rescue NameError
        return nil
      end
    end
  end
end