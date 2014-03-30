class UserFriendshipsController < ApplicationController
  before_action :authenticate_user!, only: [:new]
  before_action :log

  def new
    if params[:friend_id]
      @friend = User.where(profile_name: params[:friend_id]).first
      Rails.logger.info ">>>>>>>>>>>>>>>>>>>"
      Rails.logger.info "@friend: #{@friend.inspect}"
      Rails.logger.info ">>>>>>>>>>>>>>>>>>>"
      @user_friendship = current_user.user_friendships.new(friend: @friend)
    else
      flash[:error] = "Friend required"
    end
  rescue ActiveRecord::RecordNotFound
    render file: 'public/404', status: :not_found  
  end

  def create

    if params[:user_friendship] && params[:user_friendship].has_key?(:friend_id)
      # @friend = User.where(profile_name: params[:friend_id]).first
      # @friend = User.where(profile_name: params[:user_friendship][:friend_id]).first
      @friend = User.find(params[:user_friendship][:friend_id])
      # @friend = User.first
      Rails.logger.info ">>>>>>>>>>>>>>>>>>>"
      Rails.logger.info "@friend: #{@friend.inspect}"
      Rails.logger.info ">>>>>>>>>>>>>>>>>>>"

      @user_friendship = current_user.user_friendships.new(friend: @friend)
      @user_friendship.save
      flash[:success] = "You are now friends with #{@friend.name_display}"
      redirect_to profile_path(@friend)
    else
      flash[:error] = "Friend not found"
      redirect_to root_url
    end
  end

  def log
    Rails.logger.info ">>>>>>>>>>>>>>>>>>>"
      Rails.logger.info "@friend LOG: #{@friend.inspect}"
      Rails.logger.info ">>>>>>>>>>>>>>>>>>>"
  end
end
