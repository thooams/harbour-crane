require 'docker'
class ContainersController < ApplicationController

  def index
    @containers = ContainerPresenter.new(HarbourCrane::Container.all).render
  end

  def new
  end

  def edit
    @container = Docker::Container.get(params[:id])
  end
end
