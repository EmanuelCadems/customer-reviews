class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  protected

  # Authenticate the microservice with token based authentication
  def authenticate
    authenticate_token(ENV['USER_API_KEY']) ||
    authenticate_token(ENV['MODERATOR_API_KEY']) || render_unauthorized
  end

  def authenticate_moderator
    authenticate_token(ENV['MODERATOR_API_KEY']) || render_unauthorized
  end

  def authenticate_admin
    authenticate_token(ENV['ADMIN_API_KEY']) || render_unauthorized
  end

  def authenticate_token(api_key)
    authenticate_with_http_token do |token, options|
      token == api_key
    end
  end

  def render_unauthorized(realm = "Application")
    self.headers["WWW-Authenticate"] = %(Token realm="#{realm.gsub(/"/, "")}")
    render status: :unauthorized
  end
end
