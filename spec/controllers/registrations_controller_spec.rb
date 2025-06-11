require "rails_helper"

RSpec.describe RegistrationsController, type: :controller do
  describe "GET new" do
    it "returns a successful response" do
      get :new

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST user" do
    context "when the params are valid" do
      it "redirects to new session" do
        params = {
          user: {
            name: "John Doe",
            birthday: Date.new(2025, 1, 1),
            hometown: "São Paulo",
            email: "john.doe@example.com",
            password: "123456",
            password_confirmation: "123456"
          }
        }

        dummy_creator = double

        allow(Users::Creator).to receive(:new).and_return(dummy_creator)
        allow(dummy_creator).to receive(:create_user).and_return(User.new)

        post :create, params: params

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(new_session_path)
      end

      context "when the params are invalid" do
        it "returns a unprocessable entity status" do
          params = {
            user: {
              name: "John Doe"
            }
          }

          post :create, params: params

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
