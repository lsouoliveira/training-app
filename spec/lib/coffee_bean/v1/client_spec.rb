require 'rails_helper'

RSpec.describe CoffeeBean::V1::Client do
  describe "#initialize" do
    it "builds the client" do
      client = described_class.new(
        base_url: "http://example.com",
        app_id: "test",
        app_secret: "test"
      )

      expect(client).to be_a(CoffeeBean::V1::Client)
      expect(client.base_url).to eq("http://example.com")
    end
  end

  describe "#connection" do
    it "returns a faraday connection" do
      client = described_class.new(
        base_url: "http://example.com",
        app_id: "test",
        app_secret: "test"
      )

      expect(client.connection).to be_a(Faraday::Connection)
    end
  end

  describe "#users" do
    it "returns the users resource" do
      client = described_class.new(
        base_url: "http://example.com",
        app_id: "test",
        app_secret: "test"
      )

      expect(client.users).to be_a(CoffeeBean::V1::Resources::Users)
    end
  end
end
