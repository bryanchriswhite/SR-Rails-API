class V1::CategorizationsController < ApplicationController
  before_filter :authenticate

  def index

  end

  def create
    categorization = Categorization.new params[:categorization]
    begin categorization.save!
      @response = {status: 201, message: 'successfully created categorization', categorization: categorization}
    rescue ActiveRecord::RecordInvalid
      @response = {status: 400, message: $!.to_s, categorization: categorization}
    rescue
      @response = {status: 400, message: $!.to_s}
    ensure
      render json: @response, callback: params[:callback], status: @response[:status]
    end
  end
end
