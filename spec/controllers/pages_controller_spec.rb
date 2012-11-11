require 'spec_helper'

describe PagesController do

  ##### render views BEFORE running tests regarding content
  render_views

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end

    it "should have the right title" do
      get 'home'
      response.should have_selector( "title", :content => "Ruby | Home")
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end

    it "should have the right title" do
      get 'contact'
      response.should have_selector( "title", :content => "Ruby | Contact")
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end

    it "should have the right title" do
      get 'about'
      response.should have_selector( "title", :content => "Ruby | About")
    end
  end

  describe "when signed in" do
    before(:each) do
      @user = test_sign_in(FactoryGirl.create(:user))
      other_user = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
      other_user.follow!(@user)
    end

    it "should have the right follower/following counts" do
      get :home
      response.should have_selector("a", :href => following_user_path(@user), :content => "0 following")
      response.should have_selector("a", :href => followers_user_path(@user), :content => "1 follower")
    end
  end

end
