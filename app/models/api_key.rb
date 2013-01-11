class ApiKey < ActiveRecord::Base
  attr_accessible :access_token, :user_id
end
