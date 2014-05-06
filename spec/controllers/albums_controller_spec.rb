require 'spec_helper'

describe AlbumsController do

  include Devise::TestHelpers

  let(:user)      { create(:user)                    }
  let(:album)     { create(:album, user: user)       }
  let(:picture)   { create(:picture, album: album)   }

  before (:each) do    
    sign_in user
    @default_params = { profile_name: user.profile_name, album_id: album.id }
  end
  before { ActionMailer::Base.deliveries = [] }

  describe "#index" do
    it "is successful" do
      get :index, profile_name: user.profile_name
      expect(response).to be_success
    end
  end

  describe "#new" do
    it "is successful" do
      get :new, profile_name: user.profile_name
      expect(response).to be_success
    end
  end

  describe "#create" do
    it "creates a new album" do
      expect do
        post :create, profile_name: user.profile_name, album: { user: user, title: 'bacon and eggs?'}
      end.to change {Album.count}.by(1)
    end

    it "redirects to the homepage" do
      post :create, profile_name: user.profile_name, album: { user: user, title: 'bacon and eggs?'}
      expect(response).to redirect_to(albums_path)
    end

    it "should create an activity item for the creation of the album" do
      expect do
        post :create, profile_name: user.profile_name, album: { user: user, title: 'bacon and eggs?'}
      end.to change {Activity.count}.by(1)
    end
  end

  describe "#show" do
    it "is redirects properly" do
      get :show, profile_name: user.profile_name, id: album
      expect(response).to redirect_to(album_pictures_path(album.id))
    end
  end

  describe "#edit" do
    it "is successful" do
      get :edit, profile_name: user.profile_name, id: album
      expect(response).to be_success
    end
  end

  describe "#update" do
    it "updates the album info" do
      put :update, profile_name: user.profile_name, id: album, album: { title: album.title }
      expect(response).to redirect_to(album_pictures_path(user.profile_name, album.id))
    end

    it "should create an activity item when the album info is updated" do
      expect do
        put :update, profile_name: user.profile_name, id: album, album: { title: album.title }
      end.to change {Activity.count}.by(1)
    end
  end

  describe "#destroy" do
    it "deletes an album" do
      expect do
        delete :destroy, profile_name: user.profile_name, id: album
      end.to change { Album.count}.by(-1)
    end
  end

end
