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
            post("v1/marketing/login/users/login", body: params)
          end
        end
      end
    end
  end
end
