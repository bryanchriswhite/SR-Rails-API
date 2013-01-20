class CreateBreaks < ActiveRecord::Migration
  def change
    create_table :breaks do |t|
      t.integer :user_id
      t.integer :mod_id

      t.timestamps
    end
  end
end
