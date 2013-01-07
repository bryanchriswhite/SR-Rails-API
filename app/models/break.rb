class Break < ActiveRecord::Base
  attr_accessible :mod, :user
  belongs_to :mod
  belongs_to :user
end
