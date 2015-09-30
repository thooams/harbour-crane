class ImagesController < ApplicationController
  def index
    @images = Docker::Image.all
  end

  def new
  end

  def edit
  end
end
