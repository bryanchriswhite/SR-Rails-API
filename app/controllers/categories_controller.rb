class CategoriesController < ApplicationController
  def index
    @categories = Category.all
    render json: @categories, callback: params[:callback]
  end
end
