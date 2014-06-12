module Logan
  module ResponseHandler
    def handle_response(response, block)
      if success?(response.response)
        response.parsed_response.map { |h| block.call(h) }
      else
        handle_error(response.response)
      end
    end

    def handle_error(response)
      if response.kind_of? Net::HTTPUnauthorized
        raise Logan::AccessDeniedError
      else
        raise Logan::InvalidRequestError
      end
    end

    def success?(response)
      response.kind_of? Net::HTTPSuccess
    end
  end
end