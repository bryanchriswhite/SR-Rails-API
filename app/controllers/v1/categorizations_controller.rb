class V1::CategorizationsController < ApplicationController

  before_filter :authenticate

  def index

  end

  def create
    categorization             = Categorization.new params[:categorization]
    begin
      categorization.save!
    rescue ActiveRecord::RecordInvalid

    rescue

    ensure

    end

  end
end
