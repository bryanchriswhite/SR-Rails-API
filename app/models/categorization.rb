class Categorization < ActiveRecord::Base
  attr_accessible :category_id, :mod_id, :user_id
  belongs_to :category
  belongs_to :mod
end
