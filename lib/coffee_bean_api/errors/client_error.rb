module CoffeeBeanApi
  module Errors
    class ClientError < Error
      attr_reader :response

      def initialize(response, message = nil)
        super(message)

        @response = response
      end
    end
  end
end
