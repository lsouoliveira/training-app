class User
  include ActiveModel::API

  GENDERS = {
    male: "male",
    female: "female",
    other: "other"
  }.freeze

  attr_accessor :user_id,
                :name,
                :birthday,
                :gender,
                :hometown,
                :email,
                :picture_url,
                :password,
                :password_confirmation

  validates :name,
            :birthday,
            :gender,
            :hometown,
            :email,
            presence: true

  validate :passwords_match

  def load
    user_data = fetch_user_data
    user_profile = fetch_user_profile

    self.name = user_data["name"]
    self.birthday = Date.parse(user_data["birthday"]) rescue nil
    self.gender = user_data["gender"]
    self.hometown = user_data["hometown"]
    self.email = user_profile&.email_address
    self.picture_url = user_profile&.picture_url
  end

  private
  def passwords_match
    return if password.nil? && password_confirmation.nil?
    return if password == password_confirmation

    errors.add(:password_confirmation, :passwords_dont_match)
  end

  def fetch_user_data
    result = CoffeeBeanApi.account.datastore.objects.list("user_data", user_id:)
    result.data.first || {}
  rescue CoffeeBean::Errors::ClientError
    {}
  end

  def fetch_user_profile
    CoffeeBeanApi.account.user_management.users.fetch_user(user_id, fields: %w[ picture_url ])
  rescue CoffeeBean::Errors::ClientError => e
    nil
  end
end
