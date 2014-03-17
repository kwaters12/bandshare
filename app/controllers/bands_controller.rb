class BandsController < ApplicationController

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

  private

  def band_params
    params.require(:band).permit([:name, :genres, :links, :address])
  end

end