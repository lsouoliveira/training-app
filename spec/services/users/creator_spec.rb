require 'rails_helper'

RSpec.describe Users::Creator do
  describe "#create_user" do
    context "when the attributes are valid" do
      it "creates a new user" do
        attributes = {
          name: "John Doe",
          birthday: Date.new(2000, 1, 1),
          email: "test@example.com",
          gender: "male",
          hometown: "São Paulo"
        }

        service = Users::Creator.new(attributes)

        stub_coffee_bean_request(
          "v1/marketing/login/users",
          method: :post,
          response: {}.to_json,
          headers: {
            "Location" => "https://api.socialidnow.com/v1/marketing/login/users/1234"
          }
        )

        stub_coffee_bean_request(
          "v1/marketing/datastore/schemas/user_data/objects",
          method: :post,
          response: {}.to_json
        )

        user = service.create_user

        expect(user.valid?).to be_truthy
        expect(user.user_id).to be_present
      end
    end

    context "when the email is already taken" do
      it "returns a invalid user" do
        attributes = {
          name: "John Doe",
          birthday: Date.new(2000, 1, 1),
          email: "test@example.com",
          gender: "male",
          hometown: "São Paulo"
        }

        service = Users::Creator.new(attributes)

        response = <<-JSON
         {
           "error": "unprocessable_entity",
           "error_description": "email_address has already been taken",
           "errors": [
             {
               "attribute": "email_address",
               "message": "has already been taken",
               "code": "taken"
             }
           ]
         }
        JSON

        stub_coffee_bean_request(
          "v1/marketing/login/users",
          method: :post,
          response:,
          status: 422,
          headers: {
            "Location" => "https://api.socialidnow.com/v1/marketing/login/users/1234"
          }
        )

        user = service.create_user

        expect(user.errors.any?).to be_truthy
        expect(user.errors.details[:email]).to include(error: :taken)
      end
    end

    context "when the email is invalid" do
      it "returns a invalid user" do
        attributes = {
          name: "John Doe",
          birthday: Date.new(2000, 1, 1),
          email: "invalid_email",
          gender: "male",
          hometown: "São Paulo"
        }

        service = Users::Creator.new(attributes)

        response = <<-JSON
         {
           "error": "unprocessable_entity",
           "error_description": "email_address is invalid",
           "errors": [
             {
               "attribute": "email_address",
               "message": "invalid",
               "code": "invalid"
             }
           ]
         }
        JSON

        stub_coffee_bean_request(
          "v1/marketing/login/users",
          method: :post,
          response:,
          status: 422,
          headers: {
            "Location" => "https://api.socialidnow.com/v1/marketing/login/users/1234"
          }
        )

        user = service.create_user

        expect(user.errors.any?).to be_truthy
        expect(user.errors.details[:email]).to include(error: :invalid)
      end
    end

    context "when the datastore request fails" do
      it "adds an base error to user" do
        attributes = {
          name: "John Doe",
          birthday: Date.new(2000, 1, 1),
          email: "test@example.com",
          gender: "male",
          hometown: "São Paulo"
        }

        service = Users::Creator.new(attributes)

        stub_coffee_bean_request(
          "v1/marketing/login/users",
          method: :post,
          response: {}.to_json,
          headers: {
            "Location" => "https://api.socialidnow.com/v1/marketing/login/users/1234"
          }
        )

        stub_coffee_bean_request(
          "v1/marketing/datastore/schemas/user_data/objects",
          method: :post,
          status: 500,
          response: {}.to_json
        )

        user = service.create_user

        expect(user.errors.details[:base]).to include(error: :request_error)
      end
    end
  end
end
