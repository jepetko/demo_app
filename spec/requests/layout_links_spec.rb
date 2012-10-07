require 'spec_helper'

# das ist ein integrationstest! ob alle links korrekt funktionieren.  und korrekten title haben.

title_related_links = { "Home" => "/", "Contact" => "/contact",
                 "About" => "/about", "Help" => "/help",
                 "Sign up" => "/signup" }

click_link_related_links = { "Home" => "/", "Contact" => "/contact",
                        "About" => "/about", "Help" => "/help" }

describe "LayoutLinks" do

  describe "GET /layout_links" do

    title_related_links.each do |key,val|

      it "it should have #{key} page at #{val}" do
        get val
        response.should have_selector( 'title', :content => key )
      end

    end

  end

  ####

  it "should have right links on the layout"  do

    visit root_path

    click_link_related_links.each do |key,val|

      click_link key
      response.should have_selector( 'title', :content => key)

    end

    visit root_path  #go again to the root page because this button is only there

    click_link 'Sign up now!'
    response.should have_selector( 'title', :content => 'Sign up' )

  end

  describe "when not signed in" do
    it "should have a signin link" do
      visit root_path
      response.should have_selector( 'a', :content => 'Sign in', :href => signin_path )
    end
  end

  describe "when signed in" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      visit signin_path
      fill_in :email, :with => @user.email
      fill_in :password, :with => @user.password
      click_button
    end

    it "should have a signout link" do
      visit root_path
      response.should have_selector( 'a', :content => 'Sign out', :href => signout_path )
    end

    it "should have a profile link" do
      visit root_path
      response.should have_selector( 'a', :content => 'Profile', :href => user_path(@user))
    end
  end
end
