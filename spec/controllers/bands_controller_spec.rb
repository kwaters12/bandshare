require 'spec_helper'

describe BandsController do 

  let(:user) { create(:user) }
  let(:band) { create(:band, user: user)}

  include Devise::TestHelpers

  before (:each) do
    sign_in user
  end

  describe "#index" do
    it "is successful" do
      get :index
      expect(response).to be_success
    end

    it "finds all of the bands" do
      assigns(@bands).should be
    end

  end

  describe "#new" do
    context "when logged in" do
      it "is successful" do
        get :new
        expect(response).to be_success
      end
    end

    context "when not logged in" do
      it "redirects to the login page" do
        sign_out user
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "#create" do
    it "creates a new band" do
      expect do
        post :create, band: {name: 'DeathScream', genres: 'rap, rock', links: 'www.youtube.com', address: '66 McRae Blvd.'}
      end.to change {Band.count}.by(1)
    end

    it "should create an activity item for the creation of the band" do
      expect do
        post :create, band: {name: 'DeathScream', genres: 'rap, rock', links: 'www.youtube.com', address: '66 McRae Blvd.'}
      end.to change {Activity.count}.by(1)
    end
  end

  describe "#show" do
    it "is successful" do
      get :show, id: band
      expect(response).to be_success
    end
  end

  describe "#edit" do
    it "is successful" do
      get :edit, id: band
      expect(response).to be_success
    end
  end 

  describe "#update" do
    it "updates the band information" do
      put :update, id: band, band: { name: band.name }
      band.name = "New Name"
      expect(band.name).to eq("New Name")
    end

    it "should create an activity item when the band info is updated" do
      expect do
        put :update, id: band, band: { name: band.name }
      end.to change {Activity.count}.by(1)
    end
  end

  describe "#destroy" do
    it "destroys the band" do
      band2 = create(:band)
      expect do
        delete :destroy, id: band2
      end.to change {Band.count}.by(-1)
    end
  end
end