require 'json'

module Helpers
  module Request
    def response_body
      JSON.parse(response.body || '{}')
    end
  end
end
