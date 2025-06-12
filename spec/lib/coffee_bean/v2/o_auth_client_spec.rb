require 'rails_helper'

RSpec.describe CoffeeBean::V2::OAuthClient do
  describe "#token" do
    context "when request is successful" do
      it "returns the access token" do
        client = CoffeeBean::V2::OAuthClient.new(
          base_url: "http://example.com",
          app_id: "test",
          app_secret: "test"
        )

        params = {
          grant_type: "authorization_code",
          code: "1234",
          redirect_uri: "http://localhost:3000/oauth/callback"
        }

        stub_request(:post, "http://example.com/v2/marketing/oauth/token")
          .and_return(
            status: 200,
            body: {
              access_token: "test"
            }.to_json,
            headers: { "Content-Type" => "application/json" }
          )

        response = client.token(**params)

        expect(response[:access_token]).to eq "test"
      end
    end
  end

  describe "#user_info" do
    context "when request is successful" do
      it "returns the user info" do
        client = CoffeeBean::V2::OAuthClient.new(
          base_url: "http://example.com",
          app_id: "test",
          app_secret: "test"
        )

        stub_request(:get, "http://example.com/v2/marketing/login/user")
          .and_return(
            status: 200,
            body: {
              id: 1234
            }.to_json,
            headers: { "Content-Type" => "application/json" }
          )

        access_token = "access_token"
        response = client.user_info(access_token)

        expect(response["id"]).to eq 1234
      end
    end
  end
end
