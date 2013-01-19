include ActionController::HttpAuthentication::Digest::ControllerMethods
class ApplicationController < ActionController::API
  helper_method :current_user

  REALM = "wiglepedia login"
  private

  def authenticate
    session[:test] = 'monkeys789'
    authenticate_or_request_with_http_digest(REALM) do |username|
      @user = User.find_by_username(username)
      unless @user
        render json: {status: 401, message: 'Access Denied'}, status: 401
      end
      @user.password_hash
    end
    @user ? session[:user_id] = @user.id : nil
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  # For all responses in this controller, return the CORS access control headers.

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = 'http://localhost:8000'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, Content-Type'
    headers['Access-Control-Allow-Credentials'] = 'true'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  # If this is a preflight OPTIONS request, then short-circuit the
  # request, return only the necessary headers and return an empty
  # text/plain.

  def cors_preflight_check
    if request.method == 'OPTIONS'
      headers['Access-Control-Allow-Origin'] = 'http://localhost:8000'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, Content-Type'
      headers['Access-Control-Allow-Credentials'] = 'true'
      headers['Access-Control-Max-Age'] = '1728000'
      render :text => '', :content_type => 'text/plain'
    end
  end

  def authenticate_or_request_with_session_digest(realm = "Application", &password_procedure)
    # a_w_s_d will return nil unless session[:authorization] exists = "authenticates logged in user"
    # r_s_d_a is called if there isn't a valid session[:authorization] and will respond with the "Session-Authenticate"
    authenticate_with_session_digest(realm, &password_procedure) || request_session_digest_authentication(realm)
  end

  # Authenticate with HTTP Digest, returns true or false
  def authenticate_with_session_digest(realm = "Application", &password_procedure)
    SessionDigest.authenticate(session, request, realm, &password_procedure)
  end

  # Render output including the HTTP Digest authentication header
  def request_session_digest_authentication(realm = "Application", message = nil)
    SessionDigest.authentication_request(self, realm, message)
  end

  module SessionDigest
    extend self

    # Returns false on a valid response, true otherwise
    def authenticate(session, request, realm, &password_procedure)
      session[:authorization] && validate_digest_response(request, realm, &password_procedure)
    end

    # Returns false unless the request credentials response value matches the expected value.
    # First try the password as a ha1 digest password. If this fails, then try it as a plain
    # text password.
    def validate_digest_response(request, realm, &password_procedure)
      secret_key = secret_token(request)
      credentials = decode_credentials_property(session)
      valid_nonce = validate_nonce(secret_key, request, credentials[:nonce])

      if valid_nonce && realm == credentials[:realm] && opaque(secret_key) == credentials[:opaque]
        password = password_procedure.call(credentials[:username])
        return false unless password

        method = request.env['rack.methodoverride.original_method'] || request.env['REQUEST_METHOD']
        uri = credentials[:uri][0, 1] == '/' ? request.original_fullpath : request.original_url

        [true, false].any? do |trailing_question_mark|
          [true, false].any? do |password_is_ha1|
            _uri = trailing_question_mark ? uri + "?" : uri
            expected = expected_response(method, _uri, credentials, password, password_is_ha1)
            expected == credentials[:response]
          end
        end
      end
    end

    # Returns the expected response for a request of +http_method+ to +uri+ with the decoded +credentials+ and the expected +password+
    # Optional parameter +password_is_ha1+ is set to +true+ by default, since best practice is to store ha1 digest instead
    # of a plain-text password.
    def expected_response(http_method, uri, credentials, password, password_is_ha1=true)
      ha1 = password_is_ha1 ? password : ha1(credentials, password)
      ha2 = ::Digest::MD5.hexdigest([http_method.to_s.upcase, uri].join(':'))
      ::Digest::MD5.hexdigest([ha1, credentials[:nonce], credentials[:nc], credentials[:cnonce], credentials[:qop], ha2].join(':'))
    end

    def ha1(credentials, password)
      ::Digest::MD5.hexdigest([credentials[:username], credentials[:realm], password].join(':'))
    end

    def encode_credentials(http_method, credentials, password, password_is_ha1)
      credentials[:response] = expected_response(http_method, credentials[:uri], credentials, password, password_is_ha1)
      "Digest " + credentials.sort_by { |x| x[0].to_s }.map { |v| "#{v[0]}='#{v[1]}'" }.join(', ')
    end

    def decode_credentials_property(session)
      decode_credentials(session.authorization)
    end

    def decode_credentials(property)
      HashWithIndifferentAccess[property.to_s.gsub(/^Digest\s+/, '').split(',').map do |pair|
        key, value = pair.split('=', 2)
        [key.strip, value.to_s.gsub(/^"|"$/, '').delete('\'')]
      end]
    end

    def authentication_header(controller, realm)
      secret_key = secret_token(controller.request)
      nonce = self.nonce(secret_key)
      opaque = opaque(secret_key)
      controller.session[:www_authenticate] = %(Digest realm="#{realm}", qop="auth", algorithm=MD5, nonce="#{nonce}", opaque="#{opaque}")
      binding.pry
    end

    def authentication_request(controller, realm, message = nil)
      message ||= "HTTP Digest: Access denied.\n"
      authentication_header(controller, realm)
      controller.response_body = message
      controller.status = 401
    end

    def secret_token(request)
      secret = request.env["action_dispatch.secret_token"]
      raise "You must set config.secret_token in your app's config" if secret.blank?
      secret
    end

    # Uses an MD5 digest based on time to generate a value to be used only once.
    #
    # A server-specified data string which should be uniquely generated each time a 401 response is made.
    # It is recommended that this string be base64 or hexadecimal data.
    # Specifically, since the string is passed in the header lines as a quoted string, the double-quote character is not allowed.
    #
    # The contents of the nonce are implementation dependent.
    # The quality of the implementation depends on a good choice.
    # A nonce might, for example, be constructed as the base 64 encoding of
    #
    # => time-stamp H(time-stamp ":" ETag ":" private-key)
    #
    # where time-stamp is a server-generated time or other non-repeating value,
    # ETag is the value of the HTTP ETag header associated with the requested entity,
    # and private-key is data known only to the server.
    # With a nonce of this form a server would recalculate the hash portion after receiving the client authentication header and
    # reject the request if it did not match the nonce from that header or
    # if the time-stamp value is not recent enough. In this way the server can limit the time of the nonce's validity.
    # The inclusion of the ETag prevents a replay request for an updated version of the resource.
    # (Note: including the IP address of the client in the nonce would appear to offer the server the ability
    # to limit the reuse of the nonce to the same client that originally got it.
    # However, that would break proxy farms, where requests from a single user often go through different proxies in the farm.
    # Also, IP address spoofing is not that hard.)
    #
    # An implementation might choose not to accept a previously used nonce or a previously used digest, in order to
    # protect against a replay attack. Or, an implementation might choose to use one-time nonces or digests for
    # POST or PUT requests and a time-stamp for GET requests. For more details on the issues involved see Section 4
    # of this document.
    #
    # The nonce is opaque to the client. Composed of Time, and hash of Time with secret
    # key from the Rails session secret generated upon creation of project. Ensures
    # the time cannot be modified by client.
    def nonce(secret_key, time = Time.now)
      t = time.to_i
      hashed = [t, secret_key]
      digest = ::Digest::MD5.hexdigest(hashed.join(":"))
      ::Base64.encode64("#{t}:#{digest}").gsub("\n", '')
    end

    # Might want a shorter timeout depending on whether the request
    # is a PUT or POST, and if client is browser or web service.
    # Can be much shorter if the Stale directive is implemented. This would
    # allow a user to use new nonce without prompting user again for their
    # username and password.
    def validate_nonce(secret_key, request, value, seconds_to_timeout=5*60)
      t = ::Base64.decode64(value).split(":").first.to_i
      nonce(secret_key, t) == value && (t - Time.now.to_i).abs <= seconds_to_timeout
    end

    # Opaque based on random generation - but changing each request?
    def opaque(secret_key)
      ::Digest::MD5.hexdigest(secret_key)
    end
  end


end
