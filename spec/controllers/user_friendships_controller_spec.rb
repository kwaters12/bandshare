require 'spec_helper'

describe UserFriendshipsController do
  
  include Devise::TestHelpers

  before (:each) do
    user = create(:user)
    sign_in user
  end

  context "#index" do
    context "when not logged in" do
      it "redirect to the login page" do
        get :new
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

    context "when logged in" do
      setup do
        @friendship1 = create(:pending_user_friendship, user: users(:jason), friend: create(:user, first_name: 'Pending', last_name: 'Friend'))
        @friendship2 = create(:accepted_user_friendship, user: users(:jason), friend: create(:user, first_name: 'Active', last_name: 'Friend'))
        @friendship3 = create(:requested_user_friendship, user: users(:jason), friend: create(:user, first_name: 'Requested', last_name: 'Friend'))
        @friendship4 = user_friendships(:blocked_by_jason)

        sign_in users(:jason)
        get :index
      end

      it "get index without error" do
        assert_response :success
      end

      it "assign user_friendships" do
        assert assigns(:user_friendships)
      end

      it "display friend's names" do
        assert_match /Pending/, response.body
        assert_match /Active/, response.body
      end

      it "display pending information on a pending friendship" do
        assert_select "#user_friendship_#{@friendship1.id}" do
          assert_select "em", "Friendship is pending."
        end
      end

      it "display date information on an accepted friendship" do
        assert_select "#user_friendship_#{@friendship2.id}" do
          assert_select "em", "Friendship started #{@friendship2.updated_at}."
        end
      end

      describe "blocked users" do
        setup do
          get :index, list: 'blocked'
        end

        it "gets the index without error" do
          expect(response).to be_success
        end

        it "doesn't display pending or active friend's names" do
          assert_no_match /Pending\ Friend/, response.body
          assert_no_match /Active\ Friend/, response.body
        end

        it "displays blocked friend names" do
          assert_match /Blocked\ Friend/, response.body
        end

      end

      describe "pending friendships" do
        setup do
          get :index, list: 'pending'
        end

        it "get the index without error" do
          assert_response :success
        end

        it "not display pending or active friend's names" do
          assert_no_match /Blocked/, response.body
          assert_no_match /Active/, response.body
        end

        it "display blocked friends" do
          assert_match /Pending/, response.body
        end
      end

      describe "requested friendships" do
        setup do
          get :index, list: 'requested'
        end

        it "get the index without error" do
          assert_response :success
        end

        it "not display pending or active friend's names" do
          assert_no_match /Blocked/, response.body
          assert_no_match /Active/, response.body
        end

        it "display requested friends" do
          assert_match /Requested/, response.body
        end
      end

      describe "accepted friendships" do
        setup do
          get :index, list: 'accepted'
        end

        it "get the index without error" do
          assert_response :success
        end

        it "not display pending or active friend's names" do
          assert_no_match /Blocked/, response.body
          assert_no_match /Requested/, response.body
        end

        it "display requested friends" do
          assert_match /Active/, response.body
        end
      end
    end
  end

  describe "#new" do
    describe "when not logged in" do
      it "redirect to the login page" do
        get :new
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

    describe "when logged in" do
      setup do
        sign_in users(:jason)
      end

      it "get new without error" do
        get :new
        assert_response :success
      end

      it "it set a flash error if the friend_id param is missing" do
        get :new, {}
        assert_equal "Friend required", flash[:error]
      end

      it "display a 404 page if no friend is found" do
        get :new, friend_id: 'invalid'
        assert_response :not_found
      end

      it "display the friend's name" do
        get :new, friend_id: users(:jim).profile_name
        assert_match /#{users(:jim).full_name}/, response.body
      end

      it "assign a user friendship" do
        get :new, friend_id: users(:jim).profile_name
        assert assigns(:user_friendship)
      end

      it "assign a user friendship with the user as current user" do
        get :new, friend_id: users(:jim).profile_name
        assert_equal assigns(:user_friendship).user, users(:jason)
      end

      it "assign a user friendship with the correct friend" do
        get :new, friend_id: users(:jim).profile_name
        assert_equal assigns(:user_friendship).friend, users(:jim)
      end
    end
  end
  
  describe "#create" do
    describe "when not logged in" do
      it "redirect to the login page" do
        get :new
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

    describe "when logged in" do
      setup do
        sign_in users(:jason)
      end

      describe "with no friend_id" do
        setup do
          post :create
        end

        it "set the flash error message" do
          assert !flash[:error].empty?
        end

        it "set redirect to root" do
          assert_redirected_to root_path
        end
      end

      describe "with a valid friend_id" do
        setup do
          post :create, user_friendship: { friend_id: users(:mike).profile_name }
        end

        it "assign a friend object" do
          assert_equal users(:mike), assigns(:friend)
        end

        it "assign a user_friendship object" do
          assert assigns(:user_friendship)
          assert_equal users(:jason), assigns(:user_friendship).user
          assert_equal users(:mike), assigns(:user_friendship).friend
        end

        it "create a user friendship" do
          assert users(:jason).friends.include?(users(:mike))
        end
      end


    end
  end

  describe "#edit" do
    describe "when not logged in" do
      it "redirect to the login page" do
        get :edit, id: 1
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

    describe "when logged in" do
      setup do
        @user_friendship = create(:pending_user_friendship, user: users(:jason))
        sign_in users(:jason)
        get :edit, id: @user_friendship
      end

      it "assign a user friendship" do
        assert assigns(:user_friendship)
        assert_equal @user_friendship, assigns(:user_friendship)
      end

      it "assign a friend" do
        assert assigns(:friend)
        assert_equal @user_friendship.friend, assigns(:friend)
      end
    end
  end


  describe "#accept" do
    describe "when not logged in" do
      it "redirect to the login page" do
        put :accept, id: 1
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

    describe "when logged in" do
      setup do
        @friend = create(:user)
        @user_friendship = create(:pending_user_friendship, user: users(:jason), friend: @friend)
        create(:pending_user_friendship, friend: users(:jason), user: @friend)
        sign_in users(:jason)
        put :accept, id: @user_friendship
        @user_friendship.reload
      end

      it "assign a user friendship" do
        assert assigns(:user_friendship)
        assert_equal @user_friendship, assigns(:user_friendship)
      end

      it "upate the state to accepted" do
        assert_equal 'accepted', @user_friendship.state
      end
    end
  end

  describe "#delete" do
    describe "when not logged in" do
      it "redirect to the login page" do
        delete :destroy, id: 1
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

    describe "when logged in" do
      setup do
        @friend = create(:user)
        @user_friendship = create(:acccepted_user_friendship, friend: @friend, user: users(:jason))
        create(:acccepted_user_friendship, users(:jason), user: @friend)

        sign_in users(:jason)
        delete :destroy, id: @user_friendship
        @user_friendship.reload
      end

      it "delete user friendships" do
        assert_difference "UserFriendship.count", -2 do
          delete :destroy, id: @user_friendship
        end
      end

      it "set the flash" do
        delete :destroy, id: @user_friendship
        assert_equal "Friendship destroyed", flash[:success]
      end
      
    end
  end

  describe "#block" do
    describe "when not logged in" do
      it "redirects to the login page" do
        put :block, id: 1
        expect(response).to be_redirect
      end
    end

    describe "when logged in" do
      setup do
        @user_friendship = create(:pending_user_friendship, user: users(:jason))
        sign_in users(:jason)
        put :block, id: @user_friendship
        @user_friendship.reload
      end

      it "assigns a user friendship" do
        assert assigns(:user_friendship)
        assert_equal @user_friendship, assigns(:user_friendship)
      end

      it "updates the user friendship state to blocked" do
        assert_equal 'blocked', @user_friendship.state
      end
    end
  end
end
