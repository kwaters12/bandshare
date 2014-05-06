require 'spec_helper'

describe UserFriendshipsController do
  
  include Devise::TestHelpers

  let(:user)   { create(:user) }
  let(:friend) { create(:user) }
  let(:user_friendship) { create(:user_friendship, user: user, friend: friend)}

  before (:each) do
    @user = create(:user)
    @user2 = create(:user)
    sign_in @user
    sign_in @user2
    sign_in user
    sign_in friend
  end

  describe "#index" do
    context "when not logged in" do
      it "redirect to the login page" do
        sign_out @user
        sign_out @user2
        get :new
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

    context "when logged in" do
      before (:each) do
        @friendship1 = create(:pending_user_friendship, user: @user, friend: @user2)     
        @friendship2 = create(:accepted_user_friendship, user: @user, friend: @user2)
        @friendship3 = create(:requested_user_friendship, user: @user, friend: @user2)
        @friendship4 = create(:blocked_user_friendship, user: @user, friend: @user2)

        get :index
      end

      it "get index without error" do
        expect(response).to be_success
      end

      it "display pending information on a pending friendship" do
        assert_select "#user_friendship_#{@friendship1.id}" do
          assert_select "em", "Friendship is pending."
        end
      end

      # it "display date information on an accepted friendship" do
      #   assert_select "#user_friendship_#{@friendship2.id}" do
      #     assert_select "em", "Friendship started #{@friendship2.updated_at}."
      #   end
      # end

      describe "blocked users" do

        before (:each) do
          get :index, list: 'blocked'
        end

        it "gets the index without error" do
          expect(response).to be_success
        end

        it "doesn't display pending or active friend's names" do
          expect(response.body).not_to match(/Pending\ Friend/)
          expect(response.body).not_to match(/Active\ Friend/)
        end

        it "displays blocked friend names" do
          expect(response.body).to match(/Blocked\ Friend/)
        end

      end

      describe "pending friendships" do

        before (:each) do
          get :index, list: 'pending'
        end

        it "gets the index without error" do
          expect(response).to be_success
        end

        it "not display blocked or active friend's names" do
          expect(response).not_to match(/Blocked/)
          expect(response).not_to match(/Active/)
        end

        it "display pending friends" do
          expect(response.body).to match(/Pending/)
        end
      end

      describe "requested friendships" do
        before (:each) do
          get :index, list: 'requested'
        end

        it "get the index without error" do
          expect(response).to be_success
        end

        it "not display blocked or active friend's names" do
          expect(response.body).not_to match(/Blocked/)
          expect(response.body).not_to match(/Active/)
        end

        it "display requested friends" do
          expect(repsonse.body).to match(/Requested/)
        end
      end

      describe "accepted friendships" do
        before (:each) do
          get :index, list: 'accepted'
        end

        it "get the index without error" do
          expect(response).to be_success
        end

        it "not display pending or active friend's names" do
          expect(response.body).not_to match(/Blocked/)
          expect(response.body).not_to match(/Requested/)
        end

        it "display requested friends" do
          expect(response.body).to match(/Active/)
        end
      end
    end
  end

  describe "#new" do
    describe "when not logged in" do
      it "redirect to the login page" do
        sign_out @user
        get :new
        expect(response).to redirect_to login_path
      end
    end

    describe "when logged in" do
      
      it "get new without error" do
        get :new
        expect(response).to be_success
      end

      it "it set a flash error if the friend_id param is missing" do
        get :new, {}
        expect(response).to have_text("Friend required"), flash[:error]
        # assert_equal "Friend required", flash[:error]
      end

      it "display a 404 page if no friend is found" do
        get :new, friend_id: 'invalid'
        expect(response.response_code).to eq(404)
      end

      it "display the friend's name" do
        get :new, friend_id: @user2.profile_name
        expect(response.body).to match(/#{@user.name_display}/)
        # assert_match /#{@user.name_display}/, response.body
      end

      it "assign a user friendship" do
        get :new, friend_id: friend.profile_name
        assigns(user_friendship).should be
      end

      it "assign a user friendship with the user as current user" do
        get :new, friend_id: @user2.profile_name
        assigns(@user_friendship.user).should be(@user2)
        # assert_equal assigns(:user_friendship).user, @user2
      end

      it "assign a user friendship with the correct friend" do
        get :new, friend_id: users(:jim).profile_name
        assert_equal assigns(:user_friendship).friend, users(:jim)
      end
    end
  end
  
  describe "#create" do
    describe "when not logged in" do
      it "redirects to the login page" do
        get :new
        expect(response).to redirect_to(login_path)
      end
    end

    describe "when logged in" do
      before(:each) do
        sign_in @user
      end

      describe "with no friend_id" do
        before(:each) do
          post :create
        end

        it "set the flash error message" do
          flash[:error].should not_be(empty)
        end

        it "set redirect to root" do
          expect(response).to redirect_to(root_path)
        end
      end

      describe "with a valid friend_id" do
        before(:each) do
          post :create, user_friendship: { friend_id: @user2.profile_name }
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
        get :edit
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

    describe "when logged in" do
      setup do
        @user_friendship = create(:pending_user_friendship, user: @user1)
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
        sign_out @user
        put :accept, id: 1
        expect(response).to redirect_to(login_path)
      end
    end

    describe "when logged in" do
      before(:each) do
        @friend = create(:user)
        sign_in @friend
        @user_friendship = create(:pending_user_friendship, user: @user, friend: @friend)
        create(:pending_user_friendship, friend: @user, user: @friend)
        put :accept, id: @user_friendship
        @user_friendship.reload
      end

      def do_put
        put :accept, id: @user_friendship
        @user_friendship.reload
      end

      it "assign a user friendship" do
        do_put
        @user_friendship.should eq(@user_friendship)
      end

      it "updates the state to accepted" do
        do_put
        expect(@user_friendship.state).to eq('accepted')
      end

      it "should have a success flash message" do
        do_put
        flash[:success].should eq("You are now friends with #{@user_friendship.friend.first_name}")
      end

      it "creates an activity" do
        expect do
          do_put
        end.to change {Activity.count}.by(1)
      end
    end
  end

  describe "#delete" do
    # describe "when not logged in" do
    #   it "redirect to the login page" do
    #     @friendship1 = create(:accepted_user_friendship, user: @user, friend: @user2)
    #     create(:accepted_user_friendship, friend: @user2, user: @user)
    #     @friendship1.user_id = @user.id
    #     @friendship1.save
    #     delete :destroy, id: @friendship1.id
    #     expect(response).to redirect_to(login_path)
    #     # assert_response :redirect
    #     # assert_redirected_to login_path
    #   end
    # end

    describe "when logged in" do

      before(:each) do
        @friend = create(:user)
        @user_friendship = create(:accepted_user_friendship, friend: @friend, user: @user)
        create(:accepted_user_friendship, friend: @user, user: @friend)
        sign_in @user
        @user_friendship.reload
      end

      it "delete user friendships" do
        expect do
          delete :destroy, id: @user_friendship
        end.to change { UserFriendship.count }.by(-2)
      end

      it "set the flash" do
        delete :destroy, id: @user_friendship
        flash[:success].should eq("Friendship deleted")
      end
      
    end
  end

  describe "#block" do

    before (:each) do
      @user_friendship = create(:pending_user_friendship, user: @user)
      sign_in @user
      put :block, id: @user_friendship
      @user_friendship.reload
    end

    describe "when not logged in" do
      it "redirects to the login page" do
        sign_out @user
        put :block, id: 1
        expect(response).to be_redirect
      end
    end

    describe "when logged in" do      

      it "assigns a user friendship" do       
        @user_friendship.should eq(@user_friendship)
      end

      it "updates the user friendship state to blocked" do
        expect(@user_friendship.state).to eq('blocked')
      end
    end
  end
end
