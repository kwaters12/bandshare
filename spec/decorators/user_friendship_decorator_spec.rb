# require 'spec_helper'

# describe UserFriendshipDecorator do
#   describe "#sub_message" do
#     setup do
#       @friend = create(:user, first_name: 'Jim')
#     end

#     describe "with a pending user friendship" do
   
#       setup do
#         @user_friendship = create(:pending_user_friendship, friend: @friend)
#         @decorator = UserFriendshipDecorator.decorate(@user_friendship)
#       end

#       it "returns the correct message" do
#         assert_equal "<h3>Do you really want to be friends with Jim?</h3>", @decorator.sub_message
#       end
#     end

#     describe "with an accepted user friendship" do
   
#       setup do
#         @user_friendship = create(:accepted_user_friendship, friend: @friend))
#         @decorator = UserFriendshipDecorator.decorate(@user_friendship)
#       end

#       it "returns the correct message" do
#         assert_equal "<h3>You are now friends with Jim.</h3>", @decorator.sub_message
#       end
#     end


#   end

#   describe "#friendship_state" do
#     describe "with a pending user friendship" do
   
#       setup do
#         @user_friendship = create(:pending_user_friendship)
#         @decorator = UserFriendshipDecorator.decorate(@user_friendship)
#       end

#       should "return Pending" do
#         assert_equal "Pending", @decorator.friendship_state
#       end
#     end
#   end

#   describe "with an accepted user friendship" do
#     describe "#friendship_state" do
#       setup do
#         @user_friendship = create(:accepted_user_friendship)
#         @decorator = UserFriendshipDecorator.decorate(@user_friendship)
#       end

#       should "return Accepted" do
#         assert_equal "Accepted", @decorator.friendship_state
#       end
#     end
#   end

#   describe "with a requested user friendship" do
#     describe "#friendship_state" do
#       setup do
#         @user_friendship = create(:requested_user_friendship)
#         @decorator = UserFriendshipDecorator.decorate(@user_friendship)
#       end

#       should "return Requested" do
#         assert_equal "Requested", @decorator.friendship_state
#       end
#     end
#   end
# end
