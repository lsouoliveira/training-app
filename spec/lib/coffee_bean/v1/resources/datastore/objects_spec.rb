require 'rails_helper'

RSpec.describe CoffeeBean::V1::Resources::Datastore::Objects do
  describe "#create" do
    context "when request is successful" do
      it "does not raise an error" do
        client = CoffeeBean::V1::AccountClient.new(
          base_url: "http://example.com",
          api_id: "test",
          api_secret: "test"
        )
        resource = described_class.new(client)

        params = {
          object: {
            username: "John Doe"
          }
        }

        stub_request(:post, "http://example.com/v1/marketing/datastore/schemas/user_schema/objects")
          .and_return(status: 200, body: {}.to_json)

        expect do
          resource.create("user_schema", **params)
        end.not_to raise_error
      end
    end

    context "when request fails" do
      it "raises a client error" do
        client = CoffeeBean::V1::AccountClient.new(
          base_url: "http://example.com",
          api_id: "test",
          api_secret: "test"
        )
        resource = described_class.new(client)

        params = {
          object: {
            username: "John Doe"
          }
        }

        stub_request(:post, "http://example.com/v1/marketing/datastore/schemas/user_schema/objects")
          .and_return(status: 500, body: {}.to_json)

        expect do
          resource.create("user_schema", **params)
        end.to raise_error(CoffeeBean::Errors::ClientError)
      end
    end
  end

  describe "#update" do
    context "when request is successful" do
      it "updates the object" do
        client = CoffeeBean::V1::AccountClient.new(
          base_url: "http://example.com",
          api_id: "test",
          api_secret: "test"
        )
        resource = described_class.new(client)

        params = {
          object: {
            username: "John Doe"
          }
        }

        stub_request(:put, "http://example.com/v1/marketing/datastore/schemas/user_schema/objects/1234")
          .and_return(status: 200, body: {}.to_json)

        expect do
          resource.update("user_schema", "1234", **params)
        end.not_to raise_error
      end
    end

    context "when the request fails" do
      it "raises an error" do
        client = CoffeeBean::V1::AccountClient.new(
          base_url: "http://example.com",
          api_id: "test",
          api_secret: "test"
        )
        resource = described_class.new(client)

        params = {
          object: {
            name: "John Doe"
          }
        }

        stub_request(:put, "http://example.com/v1/marketing/datastore/schemas/user_schema/objects/1234")
          .and_return(status: 500, body: {}.to_json)

        expect do
          resource.update("user_schema", "1234", **params)
        end.to raise_error(CoffeeBean::Errors::ClientError)
      end
    end
  end

  describe "#list" do
    context "when request is successful" do
      it "returns a list of objects" do
        client = CoffeeBean::V1::AccountClient.new(
          base_url: "http://example.com",
          api_id: "test",
          api_secret: "test"
        )
        resource = described_class.new(client)

        params = {
          object: {
            username: "John Doe"
          }
        }

        user_data_response = <<-JSON
          {
            "total": 2,
            "count": 2,
            "offset": 0,
            "results": [
              {
                "object_id": "54481188e5cb7cffe4000003",
                "user_id": 1234,
                "birthday": "2025-01-01",
                "gender": "male",
                "hometown": "São Paulo",
                "name": "John Doe"
              }
            ]
          }
        JSON

        stub_request(:get, "http://example.com/v1/marketing/datastore/schemas/user_schema/objects")
          .and_return(status: 200, body: user_data_response, headers: { "Content-Type" => "application/json" })

        response = resource.list("user_schema")

        expect(response.total).to eq 2
      end
    end

    context "when the request fails" do
      it "raises an error" do
        client = CoffeeBean::V1::AccountClient.new(
          base_url: "http://example.com",
          api_id: "test",
          api_secret: "test"
        )
        resource = described_class.new(client)


        stub_request(:get, "http://example.com/v1/marketing/datastore/schemas/user_schema/objects")
          .and_return(status: 500, body: {}.to_json, headers: { "Content-Type" => "application/json" })

        expect do
          resource.list("user_schema")
        end.to raise_error(CoffeeBean::Errors::ClientError)
      end
    end
  end
end
