require 'spec_helper'

describe PicturesController do

  let(:user)      { create(:user)                    }
  let(:album)     { create(:album, user: user)       }
  let(:picture)   { create(:picture, album: album)   }

  include Devise::TestHelpers

  before (:each) do
    sign_in user
    @default_params = { profile_name: user.profile_name, album_id: album.id }
  end

  describe "#index" do
    it "is successful" do
      get :index, @default_params
      expect(response).to be_success
    end
  end

  describe "#new" do
    it "it is successful" do
      get :new, @default_params
      expect(response).to be_success
    end
  end

  describe "#create" do
    it "adds a new picture" do
      expect do
        post :create, @default_params.merge(picture: { caption: picture.caption, description: picture.description})
      end.to change {Picture.count}.by(2)
    end

    it "should create an activity item for the picture" do
      expect do
        post :create, @default_params.merge(picture: { caption: picture.caption, description: picture.description})
      end.to change {Activity.count}.by(1)
    end
  end

  describe "#show" do
    it "shows the picture" do
      get :show, @default_params.merge(id: picture)
      expect(response).to be_success
    end
  end

  describe "#edit" do
    it "is successful" do
      get :edit, @default_params.merge(id: picture)
      expect(response).to be_success
    end
  end

  describe "#update" do
    it "updates the picture information" do
      put :update, @default_params.merge(id: picture, picture: { caption: picture.caption, description: picture.description})
      picture.caption = "new caption"
      expect(picture.caption).to eq("new caption")
    end

    it "redirects to the album" do
      put :update, @default_params.merge(id: picture, picture: { caption: picture.caption, description: picture.description})
      expect(response).to redirect_to(album_pictures_path(@default_params))
    end

    it "should create an activity item when the picture info is updated" do
      expect do
        put :update, @default_params.merge(id: picture, picture: { caption: picture.caption, description: picture.description})
      end.to change {Activity.count}.by(1)
    end
  end

  describe "#destroy" do

    it "destroys the picture" do
      picture2 = create(:picture, album: album)
      expect do
        delete :destroy, @default_params.merge(id: picture2)
      end.to change {Picture.count}.by(-1)
    end
  end

end
