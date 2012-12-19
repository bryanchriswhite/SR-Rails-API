class V1::CategorizationsController < ApplicationController

  before_filter :authenticate

  def index

  end

  def create
    #before_filter :restrict_access

    # @categorizations = []
    # params[:category].each do |category|
    #   category.each do |category_name|
    # end
    # end
    #binding.pry
    categorization             = Categorization.new
    categorization.mod_id      = params[:mod_id]
    categorization.user_id     = params[:user_id]
    categorization.category_id = params[:category_id]
    if categorization.save

      head :ok
    else
      head :bad_request
    end

  end

  #private
  #def restict_access
  #  authenticate_or_request_with_http_token do |token, options|
  #    ApiKey.exists?(access_token: token)
  #  end
  #end
end
