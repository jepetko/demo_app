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
end
