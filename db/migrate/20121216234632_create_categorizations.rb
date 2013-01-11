class CreateCategorizations < ActiveRecord::Migration
  def change
    create_table :categorizations do |t|
      t.integer :user_id
      t.integer :mod_id
      t.integer :category_id

      t.timestamps
    end
  end
end
