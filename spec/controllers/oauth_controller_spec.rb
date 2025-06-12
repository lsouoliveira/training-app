require "rails_helper"

RSpec.describe OauthController, type: :controller do
  describe "POST #authorize" do
    it "redirects to the authorize url" do
      get :authorize

      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET #callback" do
    context "when the state param is valid" do
      it "redirects to the root path" do
        params = {
          state: "1234"
        }

        session[:state] = "1234"

        dummy_client = double

        allow(CoffeeBeanApi).to receive(:oauth).and_return(dummy_client)
        allow(dummy_client).to receive(:token).and_return({ access_token: "access_token" })
        allow(dummy_client).to receive(:user_info).and_return({ "id" => "1234" })

        get :callback, params: params

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
      end
    end

    context "when the state param is not valid" do
      it "returns unauthorized response" do
        params = {
          state: "1234"
        }

        get :callback, params: params

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
