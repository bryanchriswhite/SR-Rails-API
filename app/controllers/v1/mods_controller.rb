class V1::ModsController < ApplicationController
  before_filter :authenticate, only: :broken

  def index
    @mods = Mod.all
    render json: @mods, callback: params[:callback]
  end

  def uncategorized
    @mods = Mod.uncategorized.where(broken: false).limit(100)
  end

  def show
    @mod = Mod.find params[:id]
    render json: @mod, callback: params[:callback]
  end

  def broken
    @mod = Mod.find params[:id]
    @mod.broken = true
    Break.create {user: current_user, mod: @mod}
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
