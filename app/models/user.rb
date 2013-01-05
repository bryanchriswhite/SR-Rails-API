class User < ActiveRecord::Base
  attr_accessible :email, :username, :password_hash
  #attr_protected :password_hash

  validates_presence_of :email, :username, :password_hash
  validates_uniqueness_of :email, :username

  #TODO: decide whether to protect password_hash or not
  #def hash_password(password, realm="Application")
  #  self.password_hash = Digest::MD5.hexdigest("#{self.username}:#{realm}:#{password}")
  #end
end
