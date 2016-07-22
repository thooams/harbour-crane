class ImagesController < ApplicationController

  before_action :set_image, only: [:show, :destroy]

  def index
    @images = ImagePresenter.new(Image.all).images
  end

  def new
  end

  def show
    @image = ImagePresenter.new(@raw_image).image
  end

  def create
    Image.pull(image_params[:name], image_params[:tag])
    respond_to do |format|
      format.html { redirect_to images_url, notice: 'Image was successfully added.' }
      format.json { head :no_content }
    end
  end

  def destroy
    @raw_image.destroy
    respond_to do |format|
      format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_image
    @raw_image = Image.find(params[:id])
  end

  def image_params
    params.require(:image).permit(:name, :tag)
  end

end
