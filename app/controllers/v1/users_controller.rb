class V1::UsersController < ApplicationController
  before_filter :authenticate, except: :create

  def index
    #logs the user in using `before_filter`
    render json: {status: 200, message: 'successfully authenticated', user: current_user}, callback: params[:callback]
  end

  def create
    user = User.new(params[:user])
    begin user.save!
      @response = {status: 201, message: 'successfully created user', user: current_user}
    rescue ActiveRecord::RecordInvalid
      @response = {status: 400, message: $!.to_s}
    ensure
      render json: @response
    end
  end

end
