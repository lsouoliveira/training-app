module CoffeeBean
  module V1
    class DatastoreClient
      attr_reader :base_url

      def initialize(base_url:, api_id:, api_secret:)
        @base_url = base_url
        @api_id = api_id
        @api_secret = api_secret
      end

      def objects
        @_datastore ||= Resources::Datastore::Objects.new(self)
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
