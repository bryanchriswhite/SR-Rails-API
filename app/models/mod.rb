class Mod < ActiveRecord::Base
  attr_accessible :author, :forum_url, :minecraft_version, :name, :created_at
end
