class HomepageController < ApplicationController
  before_action :find_user
  respond_to :html, :json

  def index
    # if params[:tag]
    #   @bands = Band.tagged_with(params[:tag])
    #   @statuses = Status.tagged_with(params[:tag])
    # else
    #   @bands = Band.order('created_at desc').all
    #   @statuses = Status.order('created_at desc').all
    # end
    params[:page] ||= 1
    @activities = Activity.for_user(current_user, params)
    respond_with @activities

  end

  private

  def find_user
    if user_signed_in?
      @user = current_user || User.find_by_profile_name(params[:id]) 
      if @user
        @bands = @user.bands.all
        render action: :index
      else
        render file: 'public/404', status: 404, formats: [:html]
      end
    end
  end

end