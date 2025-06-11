module Helpers
  module Authentication
    def login_as(user)
      Current.user = user
      cookies.signed.permanent[:user_id] = { value: user.user_id, httponly: true, same_site: :lax }
    end
  end
end
