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
    @band.build_document
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

    @band.transaction do
      @band.update_attributes(band_params)
      @document.update_attributes(document_params) if @document
      raise ActiveRecord::Rollback unless @band.valid? && @document.try(:valid?)
    end
    
      # if @band.update_attributes(band_params) && @document 
    respond_to do |format|    
      format.html {redirect_to @band, notice: "Band was updated successfully."}
      format.json { head :no_content }
    end

  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html do
        flash.now[:error] = "Update failed."
        render :edit 
      end
      format.json { render json: @band.errors, status: :unprocessable_entity }
    end
  end

  private

  def find_band
    @band = Band.find(params[:id])
  end

  def document_params
    params.permit([:attachment, :remove_attachment])
  end

  def band_params
    params.require(:band).permit([:name, :tag_list, :links, :address, {document_attributes: [:attachment, :remove_attachment]}, :user_id, :document_id, {user_ids:[]}])
  end

end