require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :name => "My first user", :email => "user@example.com", :password => "foolish", :password_confirmation => "foolish" }
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

    usr = User.create!(@attr)      # create 1. user

    user_with_duplicate_email = User.new(@attr)      # instantiate 2.user with the same email
    user_with_duplicate_email.should_not be_valid

    user_with_duplicate_email_uppercase = User.new(@attr.merge(:email => @attr[:email].upcase))     # instantiate 3. user with the same email (upper)
    user_with_duplicate_email_uppercase.should_not be_valid
  end

  describe "password validations" do
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
  end

  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)

      allUsers = User.all
      puts allUsers
      allUsers.each do |usr|
        puts usr.email.inspect + ";" + usr.salt.inspect
      end
    end

    it "should have an encrypted password attribute and salt attribute" do
      @user.should respond_to(:encrypted_password)
      @user.should respond_to(:salt)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method test" do

      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end

      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end

    end


    describe "authenticate method" do
      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate( @attr[:email], "bullshit")
        wrong_password_user.should be_nil
      end

      it "should return nil for an email address with no user" do
        nonexistent_user = User.authenticate( "somebody@xxx.xx", @attr[:password] )
        nonexistent_user.should be_nil
      end

      it "should return the user on email/password match" do
        existent_user = User.authenticate( @attr[:email], @attr[:password])
        existent_user.should == @user
      end

    end

  end


end