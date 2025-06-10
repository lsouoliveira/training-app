class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.valid?
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user)
      .permit(
        :name,
        :birthday,
        :gender,
        :hometown,
        :email,
        :password,
        :password_confirmation
      )
  end
end
