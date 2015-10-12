class ImagesController < ApplicationController

  def index
    @images = ImagePresenter.new(Image.all).images
  end

  def show
    image = Image.find(params[:id])
    @image = ImagePresenter.new(image).image
  end

  def destroy
    @image = Image.find(params[:id])
    @image.delete(force: true)
    respond_to do |format|
      format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

end
