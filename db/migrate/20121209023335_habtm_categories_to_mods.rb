class HabtmCategoriesToMods < ActiveRecord::Migration
  def up
    create_table :categories_mods do |t|
      t.integer :category_id
      t.integer :mod_id
    end
  end

  def down
    drop_table :categories_mods
  end
end
