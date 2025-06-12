class OauthController < ApplicationController
  allow_unauthenticated_access only: %i[ authorize callback ]

  before_action :ensure_state_is_valid, only: :callback

  def authorize
    query_params = {
      response_type: "code",
      client_id: 1412,
      scope: "email",
      redirect_uri: Rails.application.credentials.coffee_bean_app_redirect_uri,
      state: SecureRandom.hex(12)
    }

    session[:state] = query_params[:state]

    redirect_to authorize_url(query_params), allow_other_host: true
  end

  def callback
    payload = {
      grant_type: "authorization_code",
      code: callback_params[:code],
      redirect_uri: Rails.application.credentials.coffee_bean_app_redirect_uri
    }

    response = CoffeeBeanApi.oauth.token(**payload)
    user_info = CoffeeBeanApi.oauth.user_info(response[:access_token])

    start_new_session_for(User.new(user_id: user_info["id"]))

    redirect_to root_path
  rescue CoffeeBean::Errors::ClientError => e
    redirect_to root_path, alert: "Invalid credentials."
  end

  def ensure_state_is_valid
    return if session[:state] == params[:state]

    head :unauthorized
  end

  private
  def callback_params
    params.permit(:code, :state)
  end

  def authorize_url(params)
    "#{Rails.application.credentials.coffee_bean_app_authorize_url}?#{params.to_query}"
  end
end
