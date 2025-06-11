module Helpers
  module CoffeeBeanApi
    BASE_URL = Rails.application.credentials.coffee_bean_api_base_url

    def stub_coffee_bean_request(path, response:, method: :get, status: 200, headers: {})
      stub_request(method, URI.join(BASE_URL, path).to_s)
        .and_return(
          status:,
          body: response,
          headers: {
            "Content-Type" => "application/json"
          }.merge(headers)
        )
    end
  end
end
