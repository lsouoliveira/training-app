require 'rails_helper'

RSpec.describe User, type: :model do
  it "initializes a new user" do
    user = User.new(user_id: "1234")

    expect(user.user_id).to eq "1234"
  end

  describe "#load" do
    it "loads the user info from the remote apis" do
      user = User.new(user_id: 1234)

      profile_response = <<-JSON
        {
          "id": 1234,
          "signed_in_at": "2013-08-08T03:32:40Z",
          "signed_up_at": "2012-10-04T14:34:10Z",
          "token": "12345678901234567890123456789012",
          "username": "john_doe",
          "email_address": "john_doe@domain.com",
          "active": true,
          "confirmed": true,
          "locked": false,
          "profile": {
            "picture_url": "http://example.com/image.png"
          }
        }
      JSON

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

      stub_coffee_bean_request(
        "v1/marketing/login/users/1234?fields%5B%5D=picture_url",
        response: profile_response
      )

      stub_coffee_bean_request(
        "v1/marketing/datastore/schemas/user_data/objects?user_id=1234",
        response: user_data_response
      )

      user.load

      expect(user.name).to eq "John Doe"
      expect(user.email).to eq "john_doe@domain.com"
      expect(user.picture_url).to eq "http://example.com/image.png"
      expect(user.gender).to eq "male"
      expect(user.birthday).to eq Date.new(2025, 1, 1)
      expect(user.hometown).to eq "São Paulo"
    end
  end
end
