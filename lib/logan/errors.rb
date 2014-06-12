module Logan
  class Error < StandardError
    attr_reader :code
    attr_reader :message

    def initialize(code, message)
      @code = code.to_sym
      @message = message
    end

    def to_json
      JSON.generate({error: @code.to_s, error_description: @message})
    end

  end

  class AccessDeniedError < Error
    def initialize
      super :access_denied, "You are now allowed to access this resource."
    end
  end

  class InvalidRequestError < Error
    def initialize
      super :invalid_request, "The request has wrong parameters."
    end
  end
end