require 'docker'
class ContainersController < ApplicationController

  before_action :set_container, only: [:edit, :stop]

  def index
    @containers = ContainerPresenter.new(Container.all).containers
  end

  def edit
  end

  def stop
    @container.stop
    respond_to do |format|
      format.html { redirect_to containers_path, notice: 'Container was successfully stopped.' }
    end
  end

  private

  def set_container
    @container = Docker::Container.get(params[:id])
  end

end
