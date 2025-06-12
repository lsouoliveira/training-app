module CoffeeBean
  class Resource
    attr_reader :client

    def initialize(client)
      @client = client
    end

    private
    def get(url, params: {}, headers: {})
      perform_request :get, url, params, headers
    end

    def post(url, body: {}, headers: {})
      perform_request :post, url, body, headers
    end

    def put(url, body: {}, headers: {})
      perform_request :put, url, body, headers
    end

    def perform_request(method, *args)
      handle_response client.connection.public_send(method, *args)
    rescue Faraday::ConnectionFailed => e
      raise Errors::Error, e.message
    end

    def handle_response(response)
      return response if response.success?

      handle_error_response(response)
    end

    def handle_error_response(response)
      case response.status
      in [ 401 ]
        raise Errors::UnauthorizedError, response.body, "Unauthorized API request"
      in [ 400, 422 ]
        raise Errors::RequestError, response.body, "Invalid API request."
      else
        raise Errors::ClientError, response.body, "API Client error"
      end
    end
  end
end
