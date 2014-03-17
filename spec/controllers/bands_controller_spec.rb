require 'spec_helper'

describe BandsController do 

  describe "#new" do
    it "is successful" do
      get :new
      expect(response).to be_success
    end
  end

  describe "#create" do
    it "creates a new band" do
      expect do
        post :create, band: {name: 'DeathScream', genres: 'rap, rock', links: 'www.youtube.com', address: '66 McRae Blvd.'}
      end.to change {Band.count}.by(1)
    end
  end
end