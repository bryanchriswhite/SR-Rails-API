class Categorization < ActiveRecord::Base
  attr_accessible :category, :mod, :user
  belongs_to :user
  belongs_to :category
  belongs_to :mod

  validates_presence_of :category, :mod, :user
  validates :user_id, :uniqueness => {:scope => [:mod_id, :category_id]}
end
