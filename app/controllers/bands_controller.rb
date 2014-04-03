class BandsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_band, except: [:index, :new, :create]
  
  def new
    @band = current_user.bands.new
    @band.build_document
    respond_to  do |format|
      format.html
      format.json { render json: @band}
    end
  end

  def create
    @band = current_user.bands.new band_params
    @band.build_documen
    if @band.save 
      redirect_to root_url, notice: "Band added!"
    else
      render :new
    end
  end

  def edit
    @band.build_document
  end

  def show
  end

  def update
    @document = @band.document
    respond_to do |format|
      if @band.update_attributes(band_params) && @document && @document.update_attributes(params[:document_attributes])
        format.html {redirect_to @band, notice: "Band was updated successfully."}
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json { render json: @band.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def find_band
    @band = Band.find(params[:id])
  end

  def band_params
    params.require(:band).permit([:name, :tag_list, :links, :address, {document_attributes: [:attachment, :remove_attachment]}, :user_id, :document_id, {user_ids:[]}])
  end

end