module CoffeeBean
  module V1
    class AccountClient
      attr_reader :base_url

      def initialize(base_url:, api_id:, api_secret:)
        @base_url = base_url
        @api_id = api_id
        @api_secret = api_secret
      end

      def datastore
        @_datastore ||= Resources::Datastore.new(self)
      end

      def user_management
        @_user_management ||= Resources::UserManagement.new(self)
      end

      def connection
        @_connection ||= Faraday.new(base_url) do |conn|
          conn.request :authorization, :basic, @api_id, @api_secret
          conn.request :json

          conn.response :json, content_type: "application/json"

          conn.adapter Faraday.default_adapter
        end
      end
    end
  end
end
