class Challenge < ActiveRecord::Base
  attr_accessible :answer, :link, :question
  validates_presence_of :answer
end
