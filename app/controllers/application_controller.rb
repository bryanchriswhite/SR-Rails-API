include ActionController::HttpAuthentication::Digest::ControllerMethods
class ApplicationController < ActionController::API
  helper_method :current_user

  REALM = "wiglepedia login"
  private

  def authenticate
    authenticate_or_request_with_http_digest(REALM) do |username|
      user = User.find_by_username(username) || raise('no user found')
      session[:user_id] = user.id
      user.password_hash
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
