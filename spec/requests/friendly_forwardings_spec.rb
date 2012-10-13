require 'spec_helper'

describe "FriendlyForwardings" do
  describe "GET /friendly_forwardings" do
    it "should forward to the requested page after signin" do

      user = FactoryGirl.create(:user)
      visit edit_user_path(user)

      ######## previous trial to edit an non-signed-user will redirect to the sign-in path

      fill_in :email, :with => user.email
      fill_in :password, :with => user.password

      click_button

      ######## valid sign-in will redirect to the previous (invalid) trial to access edit page

      response.should render_template('users/edit')

    end
  end
end
