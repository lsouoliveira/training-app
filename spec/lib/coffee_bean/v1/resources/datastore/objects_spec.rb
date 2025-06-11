require 'rails_helper'

RSpec.describe CoffeeBean::V1::Resources::Datastore::Objects do
  describe "#create" do
    context "when request is successfull" do
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
end
