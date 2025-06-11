require 'rails_helper'

RSpec.describe CoffeeBean::V1::AccountClient do
  describe "#initialize" do
    it "builds the client" do
      client = described_class.new(
        base_url: "http://example.com",
        api_id: "test",
        api_secret: "test"
      )

      expect(client).to be_a(CoffeeBean::V1::AccountClient)
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

  describe "#datastore" do
    it "returns the datastore resource" do
      client = described_class.new(
        base_url: "http://example.com",
        api_id: "test",
        api_secret: "test"
      )

      expect(client.datastore).to be_a(CoffeeBean::V1::Resources::Datastore)
    end
  end
end
