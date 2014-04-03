require 'spec_helper'

describe UserFriendship do
  describe '#block!' do
    setup do
      @user_friendship = UserFriendship.request users(:jason), users(:mike)
    end

    it "sets the state to blocked" do
      @user_friendship.block!
      assert_equal 'blocked', @user_friendship.state 
      assert_equal 'blocked', @user_friendship.mutual_friendship.state
    end

    it "doesn't alow new requests once blocked" do
      @user_friendship.block!
      uf = UserFriendship.request users(:jason), users(:mike)
      assert !uf.save
    end

  end

end
