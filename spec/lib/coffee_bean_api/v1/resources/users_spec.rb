require 'rails_helper'

RSpec.describe CoffeeBeanApi::V1::Resources::Users do
  describe "#create" do
    context "when the request is successful" do
      it "does not raise an error" do
        client = CoffeeBeanApi::V1::Client.new(
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
          .and_return(status: 200, body: {}.to_json)

        expect do
          resource.create(**params)
        end.not_to raise_error
      end
    end

    context "when the request fails" do
      it "returns a client error" do
        client = CoffeeBeanApi::V1::Client.new(
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
        end.to raise_error(CoffeeBeanApi::Errors::ClientError)
      end
    end
  end

  describe "#login" do
    context "when the request is successful" do
      it "does not raise an error" do
        client = CoffeeBeanApi::V1::Client.new(
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
          .and_return(status: 200, body: {}.to_json)

        expect do
          resource.login(**params)
        end.not_to raise_error
      end
    end

    context "when the request fails" do
      it "returns a client error" do
        client = CoffeeBeanApi::V1::Client.new(
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
        end.to raise_error(CoffeeBeanApi::Errors::ClientError)
      end
    end
  end
end
