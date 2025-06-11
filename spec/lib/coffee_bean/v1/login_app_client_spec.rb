require 'rails_helper'

RSpec.describe CoffeeBean::V1::LoginAppClient do
  describe "#initialize" do
    it "builds the client" do
      client = described_class.new(
        base_url: "http://example.com",
        app_id: "test",
        app_secret: "test"
      )

      expect(client).to be_a(CoffeeBean::V1::LoginAppClient)
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

  describe "#objects" do
    it "returns the objects resource" do
      client = described_class.new(
        base_url: "http://example.com",
        app_id: "test",
        app_secret: "test"
      )

      expect(client.users).to be_a(CoffeeBean::V1::Resources::LoginApp::Users)
    end
  end
end
