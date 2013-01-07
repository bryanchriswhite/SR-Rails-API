class Mod < ActiveRecord::Base
  attr_readonly :author, :forum_url, :minecraft_version, :name, :created_at
  attr_accessible :broken
  has_and_belongs_to_many :categories
  has_many :categorizations

  scope :incomplete, find_by_sql('select * from mods where id not in (select mod_id from categorizations group by mod_id having count(mod_id) > 9)')

  def self.uncategorized user_id
    where "select mod_id from categorizations group by mod_id where user_id not #{user_id}"
  end
end
