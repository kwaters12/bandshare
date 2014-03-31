require 'spec_helper'

describe ProfilesController do
  it "should find a profile" do
    get :show
    assert_response :success
    assert_template 'profiles/show'
  end

  describe "it should render a 404 on no profile found" do
    get :show
    assert_response :not_found
  end

  describe "it shows statuses on success" do
    get :show, id: users(:jason).profile_name
    assert_not_empty assigns(:statuses)
  end

  describe "it only shows the correct user's statuses" do
    get :show, id: users(:jason).profile_name
    assigns(:statuses).each do |status|
      assert_equal users(:jason), status.user
    end
  end
end
