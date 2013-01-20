class Break < ActiveRecord::Base
  attr_accessible :mod_id, :user_id
  belongs_to :mod
  belongs_to :user

  validates_presence_of :user, :mod
  validates_uniqueness_of :user_id, scope: :mod_id
end
