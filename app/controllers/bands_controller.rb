class BandsController < ApplicationController
  before_action :find_band, except: [:index, :new, :create]
  def new
    @band = Band.new
  end

  def create
    @band = Band.new band_params

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

  def find_band
    @band = Band.find(params[:id])
  end

  def band_params
    params.require(:band).permit([:name, :tag_list, :links, :address])
  end

end