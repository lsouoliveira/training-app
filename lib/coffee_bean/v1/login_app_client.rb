module CoffeeBean
  module V1
    class LoginAppClient
      attr_reader :base_url

      def initialize(base_url:, app_id:, app_secret:)
        @base_url = base_url
        @app_id = app_id
        @app_secret = app_secret
      end

      def users
        @_users ||= Resources::LoginApp::Users.new(self)
      end

      def connection
        @_connection ||= Faraday.new(base_url) do |conn|
          conn.request :authorization, :basic, @app_id, @app_secret
          conn.request :json

          conn.response :json, content_type: "application/json"

          conn.adapter Faraday.default_adapter
        end
      end
    end
  end
end
