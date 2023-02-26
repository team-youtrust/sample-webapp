module Helpers
  module Session
    def sign_in(user)
      post '/api/session', params: { name: user.name }
    end
  end
end
