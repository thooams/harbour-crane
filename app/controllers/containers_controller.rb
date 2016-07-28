require 'docker'
class ContainersController < ApplicationController

  before_action :set_container, only: [:edit, :stop, :destroy, :start]

  def index
    @containers_presenter = ContainerPresenter.new(Container.all).containers
  end

  def show
  end

  def edit
  end

  def stop
    @container.stop
    respond_to do |format|
      format.html { redirect_to containers_path, notice: 'Container was successfully stopped.' }
    end
  end

  def start
    @container.start
    respond_to do |format|
      format.html { redirect_to containers_path, notice: 'Container was successfully started.' }
    end
  end

  def destroy
    @container.destroy
    respond_to do |format|
      format.html { redirect_to containers_path, notice: 'Container was successfully deleted.' }
    end
  end

  private

  def set_container
    @container = Container.find(params[:id])
  end

end
