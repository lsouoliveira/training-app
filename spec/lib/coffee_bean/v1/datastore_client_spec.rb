require 'rails_helper'

RSpec.describe CoffeeBean::V1::DatastoreClient do
  describe "#initialize" do
    it "builds the client" do
      client = described_class.new(
        base_url: "http://example.com",
        api_id: "test",
        api_secret: "test"
      )

      expect(client).to be_a(CoffeeBean::V1::DatastoreClient)
      expect(client.base_url).to eq("http://example.com")
    end
  end

  describe "#connection" do
    it "returns a faraday connection" do
      client = described_class.new(
        base_url: "http://example.com",
        api_id: "test",
        api_secret: "test"
      )

      expect(client.connection).to be_a(Faraday::Connection)
    end
  end

  describe "#objects" do
    it "returns the objects resource" do
      client = described_class.new(
        base_url: "http://example.com",
        api_id: "test",
        api_secret: "test"
      )

      expect(client.objects).to be_a(CoffeeBean::V1::Resources::Datastore::Objects)
    end
  end
end
