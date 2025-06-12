class SocialLoginAuthenticationsController < ApplicationController
  allow_unauthenticated_access only: %i[create]

  def create
    response = CoffeeBeanApi.login_app.users.info(
      api_secret: Rails.application.credentials.coffee_bean_app_secret,
      token: social_login_params[:token]
    )

    start_new_session_for(User.new(user_id: response.id))

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.action(:redirect_to, root_path) }
    end
  rescue CoffeeBean::Errors::ClientError
    head :unprocessable_entity
  end

  private
  def social_login_params
    params.permit(:token)
  end
end
