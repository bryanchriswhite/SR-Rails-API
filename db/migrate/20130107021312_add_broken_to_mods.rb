class AddBrokenToMods < ActiveRecord::Migration
  def change
    add_column :mods, :broken, :boolean, default: false
  end
end
