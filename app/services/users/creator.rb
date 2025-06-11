module Users
  class Creator
    def initialize(attributes)
      @attributes = attributes
    end

    def create_user
      user = User.new(**@attributes)

      return user unless user.valid?

      with_error_handler(user) do
        create_user_credentials(user)
        save_user_data_to_datastore(user)
      end

      user
    end

    private
    def with_error_handler(user)
      yield
    rescue CoffeeBean::Errors::ClientError => e
      map_api_response_errors(e.response, user)
    end

    def create_user_credentials(user)
      payload = {
        user: {
          email_address: user.email,
          password: user.password
        }
      }

      created_user = CoffeeBeanApi.login_app.users.create(**payload)
      user.user_id = created_user.id
    end

    def save_user_data_to_datastore(user)
      payload = {
        object: {
          name: user.name,
          email: user.email,
          hometown: user.hometown,
          birthday: user.birthday,
          user_id: user.user_id
        }
      }

      CoffeeBeanApi.datastore.objects.create("user_data", **payload)
    end

    def map_api_response_errors(response, user)
      body = response || {}
      errors = body["errors"] || []
      mapped_errors = errors.filter_map { map_error(it) }

      if mapped_errors.empty?
        user.errors.add(:base, :request_error)
      else
        mapped_errors.each { |attribute, type| user.errors.add(attribute, type) }
      end
    end

    def map_error(error)
      if error.values_at("attribute", "code") == [ "email_address", "taken" ]
        [ :email, :taken ]
      elsif error.values_at("attribute", "code") == [ "email_address", "invalid" ]
        [ :email, :invalid ]
      end
    end
  end
end
