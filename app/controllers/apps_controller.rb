class AppsController < ApplicationController

  def index
    @apps = Dir.entries(DockerManager::Application::COMPOSE_FILE_DIR).reject{ |n| ['.', '..'].include?(n) }
  end

  def new
  end

  def edit
    @app = OpenStruct.new(name: params[:name])
  end
end
