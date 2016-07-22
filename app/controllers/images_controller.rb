class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :destroy]

  def index
    @images = ImagePresenter.new(Image.all).images
  end

  def new
    @image = Image.new
  end

  def show
  end

  def create
    @image = Image.pull(name: image_params[:name], tag: image_params[:tag])
    respond_to do |format|
      if @image
        format.html { redirect_to images_url, notice: 'Image was successfully added.' }
        format.json { head :no_content }
      else
        format.html { render :new }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_image
    @image = Image.find(params[:id])
  end

  def image_params
    params.require(:image).permit(:name, :tag)
  end

end
