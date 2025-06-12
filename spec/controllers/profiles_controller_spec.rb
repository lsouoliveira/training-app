require "rails_helper"

RSpec.describe ProfilesController, type: :controller do
  describe "GET #edit" do
    it "returns a success response" do
      user = User.new(user_id: 1234)

      login_as(user)

      get :edit

      expect(response).to have_http_status(:ok)
    end
  end

  describe "PUT #edit" do
    context "when the params are invalid" do
      it "returns an unprocessable entity error" do
        user = User.new(user_id: 1234)

        params = {
          user: {
            name: "John Doe"
          }
        }

        login_as(user)

        put :update, params: params

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when the user data object already exists" do
      it "returns a success response" do
        user = User.new(user_id: 1234)

        params = {
          user: {
            name: "John Doe",
            gender: "male",
            hometown: "São Paulo",
            birthday: "2025-01-01"
          }
        }

        login_as(user)

        dummy_client = double
        dummy_resource = double
        dummy_objects = double
        result = double(data: [
          {
            "object_id" => "1234"
          }
        ])

        allow(CoffeeBeanApi).to receive(:account).and_return(dummy_client)
        allow(dummy_client).to receive(:datastore).and_return(dummy_resource)
        allow(dummy_resource).to receive(:objects).and_return(dummy_objects)
        allow(dummy_objects).to receive(:list).and_return(result)
        allow(dummy_objects).to receive(:update)

        put :update, params: params

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(edit_profile_path)
      end
    end

    context "when the user data object does not exist" do
      it "returns a success response" do
        user = User.new(user_id: 1234)

        params = {
          user: {
            name: "John Doe",
            gender: "male",
            hometown: "São Paulo",
            birthday: "2025-01-01"
          }
        }

        login_as(user)

        dummy_client = double
        dummy_resource = double
        dummy_objects = double
        result = double(data: [])

        allow(CoffeeBeanApi).to receive(:account).and_return(dummy_client)
        allow(dummy_client).to receive(:datastore).and_return(dummy_resource)
        allow(dummy_resource).to receive(:objects).and_return(dummy_objects)
        allow(dummy_objects).to receive(:list).and_return(result)
        allow(dummy_objects).to receive(:create)

        put :update, params: params

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(edit_profile_path)
      end
    end
  end
end
