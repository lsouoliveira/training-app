module CoffeeBean
  module V1
    module Resources
      class UserManagement
        def initialize(client)
          @client = client
        end

        def users
          @_users ||= V1::Resources::UserManagement::Users.new(@client)
        end
      end
    end
  end
end
