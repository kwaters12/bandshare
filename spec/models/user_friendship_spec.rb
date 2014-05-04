require 'spec_helper'

describe UserFriendship do
  describe '#block!' do

    before (:each) do
      user = create(:user)
      user2 = create(:user)
      @user_friendship = UserFriendship.request(user, user2)
    end

    it "sets the state to blocked" do
      @user_friendship.block!
      assert_equal 'blocked', @user_friendship.state 
      assert_equal 'blocked', @user_friendship.mutual_friendship.state
    end

    it "doesn't allow new requests once blocked" do
      # @user_friendship.block!
      # user = create(:user)
      # user2 = create(:user)
      # uf = UserFriendship.request(user, user2)
      # # expect(uf).not_to save
      # assert !uf.save
    end

  end

end
