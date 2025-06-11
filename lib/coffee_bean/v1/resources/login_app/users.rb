module CoffeeBean
  module V1
    module Resources
      module LoginApp
        class Users < Resource
          def create(**params)
            response = post("v1/marketing/login/users", body: params)

            location = response.headers["Location"] || response.headers["location"]
            id = location.split("/").last if location

            raise "Invalid user id" if id.blank?

            Objects::LoginApp::User.new(id: id.to_i)
          end

          def login(**params)
            response = post("v1/marketing/login/users/login", body: params)

            puts response.body

            Objects::LoginApp::LoginResponse.new(user_id: response.body["user_id"])
          end
        end
      end
    end
  end
end
