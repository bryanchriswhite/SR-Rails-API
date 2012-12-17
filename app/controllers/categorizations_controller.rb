class CategorizationsController < ApplicationController
  def create
    before_filter :restrict_access

    # @categorizations = []
    # params[:category].each do |category|
    #   category.each do |category_name|
    # end
    # end

    binding.pry
  end

  private

    def restict_access
      authenticate_or_request_with_http_token do |token, options|
        ApiKey.exists?(access_token: token)
      end
    end
end
