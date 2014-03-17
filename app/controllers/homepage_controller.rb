class HomepageController < ApplicationController

  def index
    if params[:tag]
      @bands = Band.tagged_with(params[:tag])
    else
      @bands = Band.all
    end
  end

end