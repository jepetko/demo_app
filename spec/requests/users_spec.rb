require 'spec_helper'

describe "Users" do

  describe "signup" do

    describe "failure" do
      it "should not make a new user" do

        lambda do
          visit signup_path

          fill_in "Name", :with => ""
          fill_in "Email", :with => ""
          fill_in "Password", :with => ""
          fill_in "Confirmation", :with => ""

          click_button

          response.should render_template('users/new')     #new because there is a redirection from create => new in failure case
          response.should have_selector("div#error_explanation")

        end.should_not change(User, :count)

      end
    end

    describe "success" do
      it "should make a new user" do
        lambda do
          visit signup_path

          fill_in "Name", :with => "Lara Golbang"
          fill_in "Email", :with => "user@example.com"
          fill_in "Password", :with => "foobar"
          fill_in "Confirmation", :with => "foobar"
          click_button
          response.should have_selector("div.flash.success", :content => "Welcome")
          response.should render_template("users/show")

        end.should change(User, :count).by(1)
      end
    end
  end

  describe "sign in/out" do

    describe "failure" do

      it "should not sign a user in" do

        visit signin_path
        fill_in :email, :with => ""
        fill_in :password, :with => ""
        click_button

        response.should have_selector( "div.flash.error", :content => "invalid")

      end

      it "should sign a user in and out" do

        user = FactoryGirl.create(:user)
        visit signin_path
        fill_in :email, :with => user.email
        fill_in :password, :with => user.password
        click_button
        controller.should be_signed_in
        #click_link "Sign out"
        #controller.should_not be_signed_in
        #controller.should be_signed_out

      end

      [:new, :create].each do |action|
        it "should deny access to '#{action}'" do
          user = FactoryGirl.create(:user)
          visit signin_path
          fill_in :email, :with => user.email
          fill_in :password, :with => user.password
          click_button

          get "users/new"
          response.should redirect_to(user_path(user))
        end
      end

    end

  end

end