module CoffeeBean
  module V2
    class OAuthClient
      attr_reader :base_url

      def initialize(base_url:, app_id:, app_secret:)
        @base_url = base_url
        @app_id = app_id
        @app_secret = app_secret
      end

      def token(**params)
        credentials = Base64.strict_encode64("#{@app_id}:#{@app_secret}")
        headers = {
          "Authorization" => "Basic #{credentials}"
        }

        response = post("v2/marketing/oauth/token", body: params, headers:)

        { access_token: response["access_token"] }
      end

      def user_info(access_token)
        headers = {
          "Authorization" => "Bearer #{access_token}"
        }

        get("v2/marketing/login/user", headers:)
      end

      def connection
        @_connection ||= Faraday.new(base_url) do |conn|
          conn.request :json

          conn.response :json, content_type: "application/json"

          conn.adapter Faraday.default_adapter
        end
      end

      private
      def post(path, body: {}, headers: {})
        perform_request(:post, path, body, headers)
      end

      def get(path, params: {}, headers: {})
        perform_request(:get, path, params, headers)
      end

      def perform_request(method, *args)
        response = connection.public_send(method, *args)

        return response.body if response.success?

        raise Errors::ClientError, response.body, "The API request failed."
      rescue Faraday::ConnectionFailed => e
        raise Errors::Error, e.message
      end
    end
  end
end
