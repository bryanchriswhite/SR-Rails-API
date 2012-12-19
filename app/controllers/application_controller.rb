include ActionController::HttpAuthentication::Digest::ControllerMethods
class ApplicationController < ActionController::API
  #TODO move this a YAML file or something...
  REALM = "054D2B166B9E2786320D77643057DF8FD08252C49DF9DF832CC6E26BF94C13C9"
  private

  def authenticate
    #binding.pry
    authenticate_or_request_with_http_digest(REALM) do |username|
      User.find_by_username(username).password_hash
    end
  end
end
