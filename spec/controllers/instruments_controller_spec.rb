require 'spec_helper'

describe InstrumentsController do

  let(:user)        { create(:user) }
  let(:instrument)  { create(:instrument, user: user)}

  include Devise::TestHelpers

  before(:each) do
    sign_in user
  end

  describe "#index" do
    it "is successful" do
      get :index
      expect(response).to be_success
    end

    it "shows a list of all of the user's instruments" do
      get :index
      assigns(@instruments).should be
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
    it "creates a new instrument" do
      expect do
        post :create, instrument: {name: 'Banjo'}
      end.to change {Instrument.count}.by(1)
    end

    it "should create an activity item for the creation of the instrument" do
      expect do
        post :create, instrument: {name: 'DeathScream'}
      end.to change {Activity.count}.by(1)
    end
  end 

  describe "#show" do
    it "is successful" do
      get :show, id: instrument
      expect(response).to be_success
    end
  end

  describe "#edit" do
    it "is successful" do
      get :edit, id: instrument
      expect(response).to be_success
    end
  end

  describe "#update" do
    it "updates the band information" do
      put :update, id: instrument, instrument: { name: instrument.name }
      instrument.name = "New Name"
      expect(instrument.name).to eq("New Name")
    end

    it "should create an activity item when the instrument info is updated" do
      expect do
        put :update, id: instrument, instrument: { name: instrument.name }
      end.to change {Activity.count}.by(1)
    end
  end
end
