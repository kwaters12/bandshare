require 'spec_helper'

describe ProfilesController do
  
  include Devise::TestHelpers

  describe "#show" do
    it "is successful" do
      get :show
      expect(response).to be_success
    end

    it "renders a 404 on no profile found" do
      get :show
      assert_response :not_found
    end 

    it "shows statuses on success" do
      get :show, id: users(:jason).profile_name
      assert_not_empty assigns(:statuses)
    end

    it "only shows the correct user's statuses" do
      get :show, id: users(:jason).profile_name
      assigns(:statuses).each do |status|
        assert_equal users(:jason), status.user
      end
    end
  end
end
