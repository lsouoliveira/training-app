require 'rails_helper'

RSpec.describe CoffeeBean::V1::Resources::UserManagement::Users do
  describe "#fetch_user" do
    context "when the request is successful" do
      it "returns an user" do
        client = CoffeeBean::V1::LoginAppClient.new(
          base_url: "http://example.com",
          app_id: "test",
          app_secret: "test"
        )
        resource = described_class.new(client)

        params = {
          fields: [ "profile_url" ]
        }

        response = <<-JSON
          {
            "id": 1234,
            "username": "john.doe",
            "email_address": "john.doe@example.com",
            "profile": {
              "picture_url": "https://example.com/image.png"
            }
          }
        JSON

        stub_request(:get, "http://example.com/v1/marketing/login/users/1234?fields%5B%5D=profile_url")
          .and_return(
            status: 200,
            body: response,
            headers: {
              "Content-Type" => "application/json"
            }
          )

        user = resource.fetch_user(1234, **params)

        expect(user.id).to eq 1234
        expect(user.username).to eq "john.doe"
        expect(user.email_address).to eq "john.doe@example.com"
        expect(user.picture_url).to eq "https://example.com/image.png"
      end
    end
  end
end
