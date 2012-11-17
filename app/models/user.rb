require 'digest'

class User < ActiveRecord::Base

  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation
  has_many :microposts, :dependent => :destroy

  has_many :relationships, :foreign_key => :follower_id, :dependent => :destroy, :autosave => true
  has_many :following, :through => :relationships, :source => :followed

  has_many :reverse_relationships, :foreign_key => :followed_id, :class_name => "Relationship", :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower

  email_regex = /([a-zA-Z0-9_-]+)+@([a-zA-Z0-9_-]+)+\.([a-zA-Z]+)/i

  validates :name, :presence => true, :length => { :maximum => 50 }
  validates :email, :presence => true, :format => { :with => email_regex }, :uniqueness => { :case_sensitive => false }
  validates :password, :presence => true, :confirmation => true, :length => { :within => 6..40 }

  before_save :encrypt_password

#  def initialize(name, email, password, password_confirmation)
    #self.name = name
    #self.email = email
    #self.password =
 # end

  def has_password?(submitted_password)
     self.encrypted_password == encrypt(submitted_password)
  end

  def feed
    Micropost.from_users_followed_by(self)
    #microposts
  end

  def follow!(followed)
    self.relationships.create!(:followed_id => followed.id)
  end

  def following?(followed)
    self.relationships.find_by_followed_id(followed)
  end

  def unfollow!(followed)
    self.relationships.find_by_followed_id(followed.id).destroy
  end


  def self.authenticate(email, submitted_password)
    usr = find_by_email(email)
    return nil if usr.nil?
    return usr if usr.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    usr = find_by_id(id)
    if usr.nil?
      nil
    else
      usr if usr.salt == cookie_salt
    end
    #(usr && usr.salt == cookie_salt) ? usr : nil
  end

  #private

    def encrypt_password
      #puts "-----------------------"
      #puts "BEFORE SAVE!!!!!!!!!!!!!! for " + self.email
      self.salt = make_salt if new_record?  #JUST 1. time
      self.encrypted_password = encrypt(password)
      #puts "salt before save:" + self.salt
      #puts "pwd before save:" + self.encrypted_password
      #puts "-----------------------"
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")  #encrypt the combination auf salt and string
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")   #make salt unique for each user
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
