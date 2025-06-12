module CoffeeBean
  module V1
    module Objects
      class User
        attr_accessor :id, :username, :email_address, :picture_url, :verified_email

        def initialize(opts = {})
          @id = opts[:id]
          @username = opts[:username]
          @email_address = opts[:email_address]
          @picture_url = opts[:picture_url]
          @verified_email = opts[:verified_email]
        end

        def self.from_json(json)
          fields = json.fetch("profile", {})

          new(
            id: json["id"],
            username: json["username"],
            email_address: json["email_address"],
            picture_url: fields["picture_url"],
            verified_email: fields["verified_email"]
          )
        end
      end
    end
  end
end
