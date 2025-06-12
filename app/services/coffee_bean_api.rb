class CoffeeBeanApi
  def self.login_app
    @_login_app_client ||= CoffeeBean::V1::LoginAppClient.new(
      base_url: Rails.application.credentials.coffee_bean_api_base_url,
      app_id: Rails.application.credentials.coffee_bean_app_id,
      app_secret: Rails.application.credentials.coffee_bean_app_secret
    )
  end

  def self.oauth
    @_login_app_client ||= CoffeeBean::V2::OAuthClient.new(
      base_url: Rails.application.credentials.coffee_bean_api_base_url,
      app_id: Rails.application.credentials.coffee_bean_app_id,
      app_secret: Rails.application.credentials.coffee_bean_app_client_secret
    )
  end

  def self.account
    @_datastore_client ||= CoffeeBean::V1::AccountClient.new(
      base_url: Rails.application.credentials.coffee_bean_api_base_url,
      api_id: Rails.application.credentials.coffee_bean_api_id,
      api_secret: Rails.application.credentials.coffee_bean_api_secret
    )
  end
end
