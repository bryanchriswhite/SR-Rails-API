class V1::ModsController < ApplicationController
  before_filter :authenticate, only: :broken
  before_filter :cors_preflight_check, only: :uncategorized
  after_filter :cors_set_access_control_headers, only: :uncategorized

  def index
    @mods = Mod.all
    render json: @mods, callback: params[:callback]
  end

  # incomplete returns mods that have < 10 categorzations by any user
  def incomplete
    @mods = Mod.where(broken: false).limit(params[:count]).incomplete
    render json: @mods, callback: params[:callback]
  end

  # uncategorized returns incomplete if current_user doesn't exist, otherwise returns mods not categorized by current_user
  def uncategorized
    session[:hello_from_rails_api] = 'bananas125'
    if current_user
      @mods = Mod.uncategorized(current_user.id).where(broken: false).limit(params[:count])
      render json: @mods, callback: params[:callback]
    else
      incomplete
    end
  end

  def show
    @mod = Mod.find params[:id]
    render json: @mod, callback: params[:callback]
  end

  def broken
    @mod = Mod.find params[:id]
    @mod.broken = true
    Break.create Hash[user: current_user, mod: @mod]
    @mod.save!
  end

  def name
    @mods = Mod.where "name like ?", "%#{params[:q]}%"
    render json: @mods, callback: params[:callback]
  end

  def version
    @mods = Mod.where "minecraft_version like ?", "%#{params[:q]}%"
    render json: @mods, callback: params[:callback]
  end

  def author
    @mods = Mod.where "author like ?", "%#{params[:q]}%"
    render json: @mods, callback: params[:callback]
  end

  def count
    @mods = Mod.limit(params[:count]).offset(params[:offset])
    render json: @mods, callback: params[:callback]
  end

  def total
    @total = Mod.all.length
    render json: @total, callback: params[:callback]
  end
end
