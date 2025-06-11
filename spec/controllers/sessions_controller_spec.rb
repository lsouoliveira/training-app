require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  describe "GET new" do
    it "returns a successful response" do
      get :new

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST create" do
    context "when the params are valid" do
      it "redirects to the home page" do
        params = {
          email: "john.doe@example.com",
          password: "123456"
        }

        dummy_client = double
        dummy_resource = double
        login_response = double(user_id: 1234)

        allow(CoffeeBeanApi).to receive(:login_app).and_return(dummy_client)
        allow(dummy_client).to receive(:users).and_return(dummy_resource)
        allow(dummy_resource).to receive(:login).and_return(login_response)

        post :create, params: params

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
      end
    end

    context "when the params are invalid" do
      it "redirects to login page" do
        params = {
          email: "john.doe@example.com",
          password: "123456"
        }

        expect(CoffeeBeanApi).to receive(:login_app).and_raise(CoffeeBean::Errors::ClientError.new({}))

        post :create, params: params

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
