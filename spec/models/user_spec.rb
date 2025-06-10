require 'rails_helper'

RSpec.describe User, type: :model do
  it "initializes a new user" do
    user = User.new(user_id: "1234")

    expect(user.user_id).to eq "1234"
  end
end
