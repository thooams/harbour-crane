class ImagesController < ApplicationController

  def index
    @images = ImagePresenter.new(HarbourCrane::Image.all).images
  end

  def show
    image = HarbourCrane::Image.find(params[:id])
    @image = ImagePresenter.new(image).image
  end

  def destroy
    @image = HarbourCrane::Image.find(params[:id])
    @image.delete(force: true)
    respond_to do |format|
      format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

end
