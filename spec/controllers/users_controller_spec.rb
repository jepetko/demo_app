require 'spec_helper'

describe UsersController do

  render_views

  describe "GET 'new'" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      puts @user.inspect
    end

    it "is successful" do
      get :show, :id => @user
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end

    it "returns http success" do
      get 'new'
      response.should be_success
    end

    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "Sign up")
    end

  end

end
