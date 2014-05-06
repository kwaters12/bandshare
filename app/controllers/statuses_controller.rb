class StatusesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  # before_action :find_status, except: [:index, :new, :create]

  def index
    @statuses = Status.order('created_at desc').all

    respond_to do |format|
      format.html 
      format.json { render json: @statuses }
    end
  end

  def show
    @status = Status.find(params[:id])

    respond_to do |format|
      format.html 
      format.json { render json: @status }
    end
  end

  def new
    @status = current_user.statuses.new
    @status.build_document

    respond_to do |format|
      format.html 
      format.json { render json: @status }
    end
  end

  def edit
    @status = current_user.statuses.find(params[:id])
  end


  def create
    @status = current_user.statuses.new status_params

    respond_to do |format|
      if @status.save
        current_user.create_activity(@status, 'created')
        format.html { redirect_to @status, notice: 'Status was successfully created.' }
        format.json { render json: @status, status: :created, location: @status }
      else
        format.html { render action: "new" }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @status = current_user.statuses.find(params[:id])
    @document = @status.document

    @status.transaction do
      @status.update_attributes status_params
      @document.update_attributes(document_params) if @document
      current_user.create_activity(@status, 'updated')
      unless @status.valid? || (@status.valid? && @document && !@document.valid?)
        raise ActiveRecord::Rollback
      end
    end
    
    respond_to do |format|
      format.html { redirect_to @status, notice: 'Status was successfully updated.' }
      format.json { head :no_content }
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html do
        flash.now[:error] = "Update failed."
        render action: "edit"
      end
      format.json { render json: @status.errors, status: :unprocessable_entity }
    end
  end

  def destroy
    @status = current_user.statuses.find(params[:id])
    @status.destroy
    # current_user.create_activity(@status, 'deleted')

    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  private

  def document_params
    params.permit([:attachment, :remove_attachment])
  end

  def status_params
    params.require(:status).permit([:content, {document_attributes: [:attachment, :remove_attachment]}])
  end
end
