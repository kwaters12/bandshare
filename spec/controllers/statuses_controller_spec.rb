require 'spec_helper'

describe StatusesController do

  include Devise::TestHelpers

  let(:user)                { create(:user) }
  let(:blocked_friend)      { create(:user) }
  let(:blocked_friendship)  { create(:blocked_user_friendship, user: user, friend: blocked_friend)}   

  before(:each) do
    sign_in user
    # sign_in blocked_friend
  end

  let(:status)              { create(:status, user: user) }
  let(:blocked_status)      { create(:status, user: blocked_friend) } 

  describe "#index" do
    context "when not logged in" do
      before(:each) do 
        sign_out user
      end

      it "should display user's posts" do
        get :index
        expect(response).to have_content("#{status.content}")
        expect(response).to have_content("#{blocked_status.content}")
      end

    end

    context "when logged in" do
      it "is successful" do
        get :index
        expect(response).to be_success
      end

      it "should not display blocked user's posts" do
        blocked_friend.statuses.create(content: 'Blocked status')
        user.statuses.create(content: 'Non-blocked status')
        get :index
        expect(response.body).to match(/Non\-blocked status/)
        expect(response.body).not_to match(/Blocked\ status/)
      end
    end
  end

  describe "#new" do
    context "when not logged in" do
      before(:each) do
        sign_out user
      end

      it "redirects the user" do
        get :new 
        expect(response).to redirect_to(new_user_session_path)
      end
    end  

    context "when logged in" do
      it "renders the new page when logged in" do
        get :new 
        expect(response).to be_success
      end
    end
  end

  describe "#create" do
    it "creates a new status" do
      expect do
        post :create, status: { content: 'Burgers' }
      end.to change {Status.count}.by(1)
    end

    it "should create an activity item for the creation of the status" do
      expect do
        post :create, status: {content: 'Burgers' }
      end.to change {Activity.count}.by(1)
    end
  end

  describe "#show" do
    it "is successful" do
      get :show, id: status
      expect(response).to be_success
    end
  end

  describe "#edit" do
    it "is successful" do
      get :edit, id: status
      expect(response).to be_success
    end
  end 

  describe "#update" do
    it "updates the status information" do
      put :update, id: status, status: { content: status.content }
      status.content = "New Content"
      expect(status.content).to eq("New Content")
    end

    it "should create an activity item when the status info is updated" do
      expect do
        put :update, id: status, status: { content: status.content }
      end.to change {Activity.count}.by(1)
    end
  end

  describe "#destroy" do
    it "destroys the status" do
      status2 = create(:status, user: user)
      expect do
        delete :destroy, id: status2
      end.to change {Status.count}.by(-1)
    end
  end

end
