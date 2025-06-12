class DashboardController < ApplicationController
  before_action :load_user_data
  before_action :ensure_user_data_is_present

  private
  def load_user_data
    return if Rails.env.test?

    Current.user.load
  end

  def ensure_user_data_is_present
    return if Rails.env.test?
    return unless missing_current_user_data?

    redirect_to edit_profile_path, alert: "Update your profile before continuing."
  end

  def missing_current_user_data?
    Current.user.name.blank? or
      Current.user.gender.blank? or
      Current.user.hometown.blank? or
      Current.user.birthday.blank?
  end
end
