class CreateBreaks < ActiveRecord::Migration
  def change
    create_table :breaks do |t|
      t.string :user_id
      t.string :mod_id

      t.timestamps
    end
  end
end
