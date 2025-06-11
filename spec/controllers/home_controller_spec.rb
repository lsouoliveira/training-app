require "rails_helper"

RSpec.describe HomeController, type: :controller do
  describe "GET index" do
    it "returns a successful response" do
      login_as(User.new(user_id: 1234))

      get :index

      expect(response).to have_http_status(:ok)
    end
  end
end
