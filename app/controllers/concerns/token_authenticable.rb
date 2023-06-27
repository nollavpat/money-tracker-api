# frozen_string_literal: true

# Authenticate using tokens
module TokenAuthenticable
  extend ActiveSupport::Concern
  include ActionController::HttpAuthentication::Token::ControllerMethods

  included do
    before_action :authenticate_token
  end

  def authenticate_token
    authenticate_or_request_with_http_token do |token|
      ActiveSupport::SecurityUtils.secure_compare(token, ENV.fetch('TOKEN'))
    end
  end
end
