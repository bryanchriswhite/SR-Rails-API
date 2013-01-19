class V1::CategorizationsController < ApplicationController
  before_filter :authenticate
  before_filter :cors_preflight_check, only: :create
  after_filter :cors_set_access_control_headers, only: :create

  def index

  end

  def create
    params[:categorization].category_ids.each do |category_id|
      hash = {mod_id: params[:categorization].mod_id, category_id: category_id}
      categorization = Categorization.new hash

      #categorization = Categorization.new params[:categorization]
      begin
        categorization.save!
      rescue ActiveRecord::RecordInvalid
        @response = {status: 400, message: $!.to_s, categorization: categorization}
        render json: @response, callback: params[:callback], status: @response[:status]
      rescue
        @response = {status: 400, message: $!.to_s}
        render json: @response, callback: params[:callback], status: @response[:status]
      end
    end
    @response = {status: 201, message: 'successfully created categorization', categorization: categorization}
    render json: @response, callback: params[:callback], status: @response[:status]
  end
end
