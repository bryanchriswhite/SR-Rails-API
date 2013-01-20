class Mod < ActiveRecord::Base
  attr_readonly :author, :forum_url, :minecraft_version, :name, :created_at
  attr_accessible :broken
  has_and_belongs_to_many :categories
  has_many :categorizations
  has_many :breaks

  scope :incomplete, where('id not in (select mod_id from categorizations group by mod_id having count(mod_id) > 9)')
  scope :not_broken_by_democracy, where('id not in (select mod_id from breaks group by mod_id having count(mod_id) > 9)')

  def self.uncategorized user_id
    where "id not in (select mod_id from categorizations where user_id = #{user_id} group by mod_id)"
  end

  def self.not_broken_by_me user_id
    where "id not in (select mod_id from breaks where user_id = #{user_id} group by mod_id)"
  end
end
