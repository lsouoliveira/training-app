class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    payload = {
      email_address: params[:email],
      password: params[:password]
    }

    response = CoffeeBeanApi.login_app.users.login(**payload)
    user = User.new(user_id: response.user_id)

    start_new_session_for user
    redirect_to after_authentication_url
  rescue CoffeeBean::Errors::ClientError => e
    redirect_to new_session_path, alert: t(".error")
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end
end
