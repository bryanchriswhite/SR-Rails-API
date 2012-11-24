class ModsController < ApplicationController
  def index
    @mods = Mod.all
    render json: @mods
  end

  def show
    @mod = Mod.find(params['id'])
    render json: @mod
  end
end
