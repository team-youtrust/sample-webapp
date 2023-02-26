require_relative './helpers/friend'
require_relative './helpers/mock'
require_relative './helpers/request'
require_relative './helpers/session'

RSpec.configure do |config|
  config.include Helpers::Friend
  config.include Helpers::Mock
  config.include Helpers::Request
  config.include Helpers::Session
end
