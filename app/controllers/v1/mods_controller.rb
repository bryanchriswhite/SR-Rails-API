class V1::ModsController < ApplicationController
  #before_filter :authenticate, only: :break
  #before_filter :set_cache_buster, only: :uncategorized
  before_filter only: :break do |controller|
    cors_preflight_check
    unless controller.request.method == 'OPTIONS'
      authenticate
    end
  end
  before_filter :cors_preflight_check, only: [:uncategorized, :break, :show]
  after_filter :cors_set_access_control_headers, only: [:uncategorized, :break, :show]

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def index
    @mods = Mod.all
    render json: @mods, callback: params[:callback]
  end

  # incomplete returns mods that have < 10 categorzations by any user
  def incomplete
    @mods = Mod.not_broken_by_democracy.limit(params[:count]).incomplete
    render json: @mods, callback: params[:callback]
  end

  # uncategorized returns incomplete if current_user doesn't exist, otherwise returns mods not categorized by current_user
  def uncategorized

    #session[:hello_from_rails_api] = 'bananas125'
    if current_user
      @mods = Mod.uncategorized(current_user.id).not_broken_by_me(current_user.id).limit(params[:count])
      render json: @mods, callback: params[:callback]
    else
      incomplete
    end
  end

  def available?
    if current_user
      unless Mod.uncategorized(current_user.id).not_broken_by_me(current_user.id).where(id: params[:id]).blank?;
        render json: true, callback: params[:callback]
      else
        render json: false, status: 400, callack: params[:callback]
      end
    end
  end

  def show
    @mod = Mod.find params[:id]
    render json: @mod, callback: params[:callback]
  end

  def broken
    @mod = Mod.find params[:id]
    @mod.broken = true
    #Break.create Hash[user: current_user, mod: @mod]
    @mod.save!
  end

  def break
    @mod = Mod.find params[:id]
    @mod.breaks.new user_id: current_user.id
    begin
      @mod.save!
      @response = {status: 201, message: 'successfully created break', resource: @mod}
    rescue ActiveRecord::RecordInvalid
      @response = {status: 400, message: "You've already flagged this mod as broken", resource: @mod}
    rescue
      @response = {status: 400, message: $!.to_s, resource: @mod}
    ensure
      render json: @response, status: @response[:status]
    end
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
