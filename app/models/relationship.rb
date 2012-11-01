class Relationship < ActiveRecord::Base
  attr_accessible :followed_id  #note: follower_id is the signed in user

  belongs_to :follower, :class_name => "User"
  belongs_to :followed, :class_name => "User"
end
