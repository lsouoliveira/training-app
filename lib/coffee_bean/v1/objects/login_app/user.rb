module CoffeeBean
  module V1
    module Objects
      module LoginApp
        class User
          attr_accessor :id, :username, :email_address

          def initialize(opts = {})
            @id = opts[:id]
            @username = opts[:username]
            @email_address = opts[:email_address]
          end
        end
      end
    end
  end
end
