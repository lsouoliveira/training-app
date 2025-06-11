module CoffeeBean
  module V1
    module Objects
      module LoginApp
        class LoginResponse
          attr_accessor :user_id

          def initialize(opts = {})
            @user_id = opts[:user_id]
          end
        end
      end
    end
  end
end
