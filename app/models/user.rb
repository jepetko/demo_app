class User < ActiveRecord::Base
  attr_accessible :email, :name

  email_regex = /([a-zA-Z0-9_-]+)+@([a-zA-Z0-9_-]+)+\.([a-zA-Z]+)/i


  validates :name, :presence => true, :length => { :maximum => 50 }
  validates :email, :presence => true, :format => { :with => email_regex }, :uniqueness => true

end
