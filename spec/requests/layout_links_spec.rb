require 'spec_helper'

static_links = { "Home" => "/", "Contact" => "/contact", "About" => "/about", "Help" => "/help" }

describe "LayoutLinks" do

  describe "GET /layout_links" do

    static_links.each do |key,val|

      it "it should have #{key} page at #{val}" do
        get val
        response.should have_selector( 'title', :content => key )
      end

    end

  end
end
