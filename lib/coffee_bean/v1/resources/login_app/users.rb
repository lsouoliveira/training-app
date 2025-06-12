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

            Objects::User.new(id: id.to_i)
          end

          def login(**params)
            response = post("v1/marketing/login/users/login", body: params)

            Objects::LoginApp::LoginResponse.new(user_id: response.body["user_id"])
          end

          def info(**params)
            response = get("v1/marketing/login/info", params:)

            Objects::User.new(id: response.body["user_id"])
          end
        end
      end
    end
  end
end
