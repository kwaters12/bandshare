require 'spec_helper'

describe ProfilesController do
  
  include Devise::TestHelpers
  before (:each) do
    @user = create(:user)
    @user2 = create(:user)
    @user_friendship = UserFriendship.request(@user, @user2)
  end

  describe "#show" do
    it "is successful" do
      get :show, id: @user.profile_name
      expect(response).to be_success
    end

    it "renders a 404 on no profile found" do
      get :show, id: "none"
      expect(response.status).to eq(404)
    end 

    it "shows bands on success" do
      get :show, id: @user.profile_name
      band = @user.bands.new(name: "Banditos")
      expect(@user.bands).not_to be_empty
    end

    it "only shows the correct user's bands" do
      get :show, id: @user.profile_name
      assigns(:bands).each do |band|
        assert_equal @user, band.user
      end
    end
  end
end
