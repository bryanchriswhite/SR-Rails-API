class V1::UsersController < ApplicationController
  before_filter :authenticate, except: :create
  before_filter :cors_preflight_check, only: :create
  after_filter :cors_set_access_control_headers, only: :create

  def index
    #logs the user in using `before_filter`
    render json: {status: 200, message: 'successfully authenticated', user: current_user}, callback: params[:callback]
  end

  def create
    user = User.new(params[:user])
    begin user.save!
      #TODO: log user in if possible, maybe set session[:user_id] manually
      @response = {status: 201, message: 'successfully created user', user: user}
    rescue ActiveRecord::RecordInvalid
      @response = {status: 400, message: $!.to_s, user: user}
    rescue
      @response = {status: 400, message: $!.to_s}
    ensure
      render json: @response, callback: params[:callback], status: @response[:status]
    end
  end

end
