class ModsController < ApplicationController
  def index
    @mods = Mod.all
    render json: @mods
  end

  def show
    @mod = Mod.find(params['id'])
    render json: @mod
  end

  def name
    @mods = Mod.where "name like ?", "%#{params[:q]}%"
    render json: @mods
  end

  def version
    @mods = Mod.where "minecraft_version like ?", "%#{params[:q]}%"
    render json: @mods
  end

  def author
    @mods = Mod.where "author like ?", "%#{params[:q]}%"
    render json: @mods
  end
end
