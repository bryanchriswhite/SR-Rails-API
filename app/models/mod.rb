class Mod < ActiveRecord::Base
  attr_readonly :author, :forum_url, :minecraft_version, :name, :created_at
  attr_accessible :broken
  has_and_belongs_to_many :categories
  has_many :categorizations

  #scope :uncategorized, all #categorizations.count < 10

  #where categorizations
end
