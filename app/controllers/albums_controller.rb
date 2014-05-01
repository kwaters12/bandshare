class AlbumsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :new, :update, :edit, :destroy]
  before_action :find_user
  before_action :find_album, only: [:edit, :update, :destroy]
  before_action :add_breadcrumbs

  def index
    @albums = @user.albums.all

    respond_to do |format|
      format.html
      format.json { render json: @albums }
    end
  end

  def show
    redirect_to album_pictures_path(params[:id])
  end 

  def new
    @album = current_user.albums.new

    respond_to  do |format|
      format.html
      format.json { render json: @album}
    end
  end

  def create
    @album = current_user.albums.new album_params
    if @album.save 
      redirect_to albums_url, notice: "Album added!"
    else
      render :new
    end
  end

  def edit
    add_breadcrumb "Editing Album"
  end

  def update 
    respond_to do |format|
      if @album.update_attributes
        format.html { redirect_to album_pictures_path(@album), notice: "Album was successfully updated."}
        format.json { head :no_content}
      else
        format.html { render action: "edit"}
        format.json { render json: @album.errors, status: :unprocessable_entity}
      end
    end
  end

  def destroy
    @album.destroy

    respond_to do |format|
      format.html { redirect_to albums_url }
      format.json { head :no_content }
    end 
  end

  #overwrite ApplicationController url_options
  def url_options
    { profile_name: params[:profile_name] }.merge(super)
  end

  private

  def add_breadcrumbs
    add_breadcrumb @user, profile_path(@user)
    add_breadcrumb 'Albums', albums_path
  end

  def find_user
    @user = User.find_by_profile_name(params[:profile_name])
  end

  def find_album
    # if signed_in? && current_user.profile_name == params[:profile_name]
      @album = current_user.albums.find(params[:id])
    # else
    #   @album = @user.albums.find(params[:album_id])
    # end
  end

  def album_params
    params.require(:album).permit([:title])
  end
end
