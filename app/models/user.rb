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
                :password,
                :password_confirmation

  validates :name,
            :birthday,
            :gender,
            :hometown,
            :email,
            presence: true

  validate :passwords_match

  private
  def passwords_match
    return if password.nil? && password_confirmation.nil?
    return if password == password_confirmation

    errors.add(:password_confirmation, :passwords_dont_match)
  end
end
