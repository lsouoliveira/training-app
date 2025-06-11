require 'rails_helper'

RSpec.describe CoffeeBean::V1::Resources::LoginApp::Users do
  describe "#create" do
    context "when the request is successful" do
      it "returns an user" do
        client = CoffeeBean::V1::LoginAppClient.new(
          base_url: "http://example.com",
          app_id: "test",
          app_secret: "test"
        )
        resource = described_class.new(client)

        params = {
          user: {
            username: "John Doe",
            email: "john.doe@example.com",
            password: "123456"
          }
        }

        stub_request(:post, "http://example.com/v1/marketing/login/users")
          .and_return(
            status: 200,
            body: {}.to_json,
            headers: {
              "Location" => "https://api.socialidnow.com/v1/marketing/login/users/1234"
            }
          )

        user = resource.create(**params)

        expect(user.id).to eq 1234
      end

      context "when the user id is missing from the location header" do
        it "raises an error" do
          client = CoffeeBean::V1::LoginAppClient.new(
            base_url: "http://example.com",
            app_id: "test",
            app_secret: "test"
          )
          resource = described_class.new(client)

          params = {
            user: {
              username: "John Doe",
              email: "john.doe@example.com",
              password: "123456"
            }
          }

          stub_request(:post, "http://example.com/v1/marketing/login/users")
            .and_return(
              status: 200,
              body: {}.to_json,
              headers: {
                "Location" => ""
              }
            )

          expect do
            resource.create(**params)
          end.to raise_error(RuntimeError)
        end
      end
    end

    context "when the request fails" do
      it "returns a client error" do
        client = CoffeeBean::V1::LoginAppClient.new(
          base_url: "http://example.com",
          app_id: "test",
          app_secret: "test"
        )
        resource = described_class.new(client)

        params = {
          user: {
            username: "John Doe",
            email: "john.doe@example.com",
            password: "123456"
          }
        }

        stub_request(:post, "http://example.com/v1/marketing/login/users")
          .and_return(status: 500, body: {}.to_json)

        expect do
          resource.create(**params)
        end.to raise_error(CoffeeBean::Errors::ClientError)
      end
    end
  end

  describe "#login" do
    context "when the request is successful" do
      it "returns a login response" do
        client = CoffeeBean::V1::LoginAppClient.new(
          base_url: "http://example.com",
          app_id: "test",
          app_secret: "test"
        )
        resource = described_class.new(client)

        params = {
          user: {
            email_address: "john.doe@example.com",
            password: "123456"
          }
        }

        response = <<-JSON
          {
            "connection": "test",
            "connection_id": "test",
            "login_token": "test",
            "user_id": 1234
          }
        JSON

        stub_request(:post, "http://example.com/v1/marketing/login/users/login")
          .and_return(status: 200, body: response, headers: { "Content-Type" => "application/json" })

        login_response = resource.login(**params)

        expect(login_response.user_id).to eq 1234
      end
    end

    context "when the request fails" do
      it "returns a client error" do
        client = CoffeeBean::V1::LoginAppClient.new(
          base_url: "http://example.com",
          app_id: "test",
          app_secret: "test"
        )
        resource = described_class.new(client)

        params = {
          user: {
            email_address: "john.doe@example.com",
            password: "123456"
          }
        }

        stub_request(:post, "http://example.com/v1/marketing/login/users/login")
          .and_return(status: 500, body: {}.to_json)

        expect do
          resource.login(**params)
        end.to raise_error(CoffeeBean::Errors::ClientError)
      end
    end
  end
end
