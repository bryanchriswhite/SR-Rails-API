class Category < ActiveRecord::Base
  attr_accessible :name, :description
  has_and_belongs_to_many :mods
  has_many :categorizations
end
