class AppsController < ApplicationController

  def index
    #@apps = Dir.entries(DockerManager::Application::COMPOSE_FILE_DIR).reject{ |n| ['.', '..'].include?(n) }
    @apps = %w(App1 App2)
  end

  def new
  end

  def edit
    @app = OpenStruct.new(slug: params[:name], name: params[:name].humanize, upstart_file_version: 2)
  end
end
