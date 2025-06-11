module CoffeeBean
  module V1
    module Resources
      class UserManagement::Users < Resource
        def fetch_user(user_id, **params)
          response = get("v1/marketing/login/users/#{user_id}", params:)

          Objects::User.from_json(response.body)
        end
      end
    end
  end
end
