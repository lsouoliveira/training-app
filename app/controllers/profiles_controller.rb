class ProfilesController < DashboardController
  skip_before_action :ensure_user_data_is_present

  def edit
    @user = Current.user
  end

  def update
    @user = User.new(profile_params)

    if @user.valid?(:profile_update)
      result = CoffeeBeanApi.account.datastore.objects.list("user_data", user_id: Current.user.user_id)
      object = result.data.first || {}

      payload = {
        object: profile_params.to_hash.merge(user_id: Current.user.user_id)
      }

      create_or_update_object(object, payload)

      redirect_to edit_profile_path, notice: "Profile update successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  rescue CoffeeBean::Errors::ClientError => e
    puts e.response.inspect

    flash.now[:alert] = "An error occurred while trying to save the user data. Check the fields and try again."

    render :edit, status: :unprocessable_entity
  end

  private
  def profile_params
    params.require(:user).permit(:name, :birthday, :gender, :hometown)
  end

  def create_or_update_object(object, payload)
    if object.blank?
      CoffeeBeanApi.account.datastore.objects.create("user_data", **payload)
    else
      CoffeeBeanApi.account.datastore.objects.update("user_data", object["object_id"], **payload)
    end
  end
end
