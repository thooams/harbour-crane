require 'docker'
class ContainersController < ApplicationController

  def index
    @containers = HarbourCrane::Application::Container.all
  end

  def new
  end

  def edit
    @container = Docker::Container.get(params[:id])
  end
end
