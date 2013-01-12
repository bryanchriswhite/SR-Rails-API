class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.text :question
      t.string :answer
      t.string :link

      t.timestamps
    end
  end
end
