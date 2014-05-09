class InstrumentsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  before_action :find_instrument, except: [:index, :new, :create]

  def index
    @instruments = Instrument.all
  end

  def new
    @instrument = current_user.instruments.new
    @instrument.build_document
    respond_to  do |format|
      format.html
      format.json { render json: @instrument}
    end
  end

  def create
    @instrument = current_user.instruments.new instrument_params
    @instrument.build_document
    if @instrument.save 
      current_user.create_activity(@instrument, 'created')
      redirect_to root_url, notice: "Band added!"
    else
      render :new
    end
  end

  def edit
    @instrument.build_document
  end

  def update
    @document = @instrument.document

    @instrument.transaction do
      @instrument.update_attributes(instrument_params)
      @document.update_attributes(document_params) if @document
      current_user.create_activity(@instrument, 'updated')
      unless @instrument.valid? || (@instrument.valid? && @document && !@document.valid?)      
        raise ActiveRecord::Rollback 
      end
    end
    
    respond_to do |format|    
      format.html {redirect_to @instrument, notice: "Gear was updated successfully."}
      format.json { head :no_content }
    end

    rescue ActiveRecord::Rollback
      respond_to do |format|
        format.html do
          flash.now[:error] = "Update failed."
          render :edit 
        end
        format.json { render json: @instrument.errors, status: :unprocessable_entity }
      end
  end

  def show

  end

  private

  def find_instrument
    @instrument = Instrument.find(params[:id])
  end

  def document_params
    params.permit([:attachment, :remove_attachment])
  end

  def instrument_params
    params.require(:instrument).permit(:name, :description, :category, :subcategory, {document_attributes: [:attachment, :remove_attachment]}, :user_id, :document_id)
  end
end
