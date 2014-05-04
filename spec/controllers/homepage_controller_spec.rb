require 'spec_helper'

describe HomepageController do 
  
  include Devise::TestHelpers

  before (:each) do
    user = create(:user)
    sign_in user
  end

  describe "#index" do
    it "is successful" do
      get :index
      expect(response).to be_success
    end

    it "shows all bands" do
      
    end
  end


end