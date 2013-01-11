class V1::ModsController < ApplicationController
  before_filter :authenticate, only: :broken

  def index
    @mods = Mod.all
    render json: @mods, callback: params[:callback]
  end

  # incomplete returns mods that have < 10 categorzations by any user
  def incomplete
    @mods = Mod.where(broken: false).limit(params[:count]).incomplete
    render json: @mods, callback: params[:callback]
  end

  # uncategorized returns mod that have not been categorized by a single user
  def uncategorized
    @mods = Mod.uncategorized(current_user.id).where(broken: false).limit(params[:count])
    render json: @mods, callback: params[:callback]
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
