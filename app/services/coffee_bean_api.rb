class CoffeeBeanApi
  def self.client
    @_client ||= CoffeeBeanApi::V1::Client.new(
      base_url: Rails.application.credentials.coffee_bean_api_base_url,
      app_id: Rails.application.credentials.coffee_bean_app_id,
      app_secret: Rails.application.credentials.coffee_bean_app_secret
    )
  end
end
