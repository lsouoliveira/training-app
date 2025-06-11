class DashboardController < ApplicationController
  before_action :load_user_data

  private
  def load_user_data
    return if Rails.env.test?

    Current.user.load
  end
end
