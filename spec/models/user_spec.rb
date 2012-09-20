require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :name => "My first user", :email => "user@example.com" }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do        #pending test
    no_name_user = User.new(@attr.merge(:name => ""))

    no_name_user.should_not be_valid
    no_name_user.valid?.should_not be_true   #wie kann man noch kombinieren... ;-)
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))

    no_email_user.should_not be_valid
    no_email_user.valid?.should be_false   #wie kann man noch kombinieren... ;-)
  end

  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[ kati@a.com kati@b.com kati@c.com ]
    addresses.each do |a|
      valid_email_user = User.new(@attr.merge(:email => a))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[ kati@a,com kati_at_b.com kati@c. ]
    addresses.each do |a|
      invalid_email_user = User.new(@attr.merge(:email => a))
      invalid_email_user.should_not be_valid

      invalid_email_user.valid?.should == false
    end
  end

  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid

    user_with_duplicate_email_uppercase = User.new(@attr.merge(:email => @attr[:email].upcase))
    user_with_duplicate_email_uppercase.should_not be_valid
  end

end
