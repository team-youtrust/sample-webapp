module UserAuthenticatable
  extend ActiveSupport::Concern

  included do
    helper_method :user_signed_in?, :current_user

    private

    def authenticate_user!
      @current_user = fetch_session_user!
    rescue StandardError
      head :unauthorized
    end

    def user_signed_in?
      !!@current_user
    end

    def current_user
      @current_user ||= fetch_session_user!
    end

    def fetch_session_user!
      User.find_by_encrypted_id!(session[:user_id])
    end
  end
end
