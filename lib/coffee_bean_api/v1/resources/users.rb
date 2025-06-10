module CoffeeBeanApi
  module V1
    module Resources
      class Users < Resource
        def create(**params)
          post("v1/marketing/login/users", body: params)
        end

        def login(**params)
          post("v1/marketing/login/users/login", body: params)
        end
      end
    end
  end
end
