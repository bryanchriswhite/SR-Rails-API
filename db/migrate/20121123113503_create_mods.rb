class CreateMods < ActiveRecord::Migration
  def change
    create_table :mods do |t|
      t.string :name
      t.string :minecraft_version
      t.string :forum_url
      t.string :author

      t.timestamps
    end
  end
end
