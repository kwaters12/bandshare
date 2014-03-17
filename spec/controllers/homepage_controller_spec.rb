require 'spec_helper'

describe HomepageController do 

  describe "#index" do
    it "is successful" do
      get :index
      expect(response).to be_success
    end
  end

end