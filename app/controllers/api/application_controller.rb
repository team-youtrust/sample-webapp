class Api::ApplicationController < ActionController::API
  include UserAuthenticatable

  rescue_from ActiveRecord::RecordNotFound do
    head :not_found
  end
end
