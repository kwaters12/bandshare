require 'spec_helper'

describe User do

  let(:user)      { create(:user)                    } 
  let(:user2)     { create(:user)                    } 
  let(:band)      { create(:band, user: user)        }
  let(:album)     { create(:album, user: user)       }
  let(:picture)   { create(:picture, album: album)   } 

  describe "#has_blocked?" do
    it "should return true if a user has blocked another user" do

    end
  end

  describe "#create_activity" do
    it "increases the activity count with an album" do
      expect do
        user.create_activity(album, 'created')
      end.to change {Activity.count}.by(1)
    end

    it "sets the targetable instance to the album passed in" do
      activity = user.create_activity(album, 'created')
      expect(album).to eq(activity.targetable)
    end

    it "increases the activity count with a picture" do
      expect do
        user.create_activity(picture, 'created')
      end.to change {Activity.count}.by(1)
    end

    it "sets the targetable instance to the picture passed in" do
      activity = user.create_activity(picture, 'created')
      expect(picture).to eq(activity.targetable)
    end


    it "increases the activity count with a band" do
      expect do
        
        user.create_activity(band, 'created')
      end.to change {Activity.count}.by(1)
    end


    it "sets the targetable instance to th
    e band passed in" do
      activity = 
      user.create_activity(band, 'created')
      expect(band).to eq(activity.targetable)
    end
  end
end
