require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  describe "GET new" do
    it "returns a successful response" do
      get :new

      expect(response).to have_http_status(:ok)
    end
  end
end
