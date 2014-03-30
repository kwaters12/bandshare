class BandsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_band, except: [:index, :new, :create]
  # before_save(:on => :create) :assign_band_owner
  
  def new
    @band = Band.new
  end

  def create
    @band = current_user.bands.new band_params


    if @band.save 
      redirect_to root_url, notice: "Band added!"
    else
      render :new
    end
  end

  def edit
  end

  def show
  end

  def update
    if @band.update_attributes(band_params)
      redirect_to band_path
    else
      render :edit
    end
  end

  private

  # def assign_band_owner

  # end
  def find_band
    @band = Band.find(params[:id])
  end

  def band_params
    params.require(:band).permit([:name, :tag_list, :links, :address, {user_ids:[]}])
  end

end