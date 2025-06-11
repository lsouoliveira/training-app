class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = Users::Creator.new(user_params.to_hash).create_user

    if @user.errors.any?
      render :new, status: :unprocessable_entity
    else
      redirect_to new_session_path, notice: t(".success")
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
