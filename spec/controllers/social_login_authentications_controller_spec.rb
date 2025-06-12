require "rails_helper"

RSpec.describe SocialLoginAuthenticationsController, type: :controller do
  describe "POST #create" do
    context "when the token is valid" do
      it "redirects to the home page" do
        params = {
          token: "1234"
        }

        dummy_client = double
        dummy_resource = double
        info_response = double(id: 1234)

        allow(CoffeeBeanApi).to receive(:login_app).and_return(dummy_client)
        allow(dummy_client).to receive(:users).and_return(dummy_resource)
        allow(dummy_resource).to receive(:info).and_return(info_response)

        post :create, params: params, format: :turbo_stream

        expect(response).to have_http_status(:ok)
      end
    end

    context "when the token is invalid" do
      it "returns an unprocessable entity status" do
        params = {
          token: "1234"
        }

        dummy_client = double
        dummy_resource = double
        info_response = double(id: 1234)

        allow(CoffeeBeanApi).to receive(:login_app).and_return(dummy_client)
        allow(dummy_client).to receive(:users).and_return(dummy_resource)
        expect(dummy_resource).to receive(:info).and_raise(CoffeeBean::Errors::ClientError.new({}))

        post :create, params: params, format: :turbo_stream

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
