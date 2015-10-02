class AppsController < ApplicationController

  def index
    #@apps = Dir.entries(DockerManager::Application::COMPOSE_FILE_DIR).reject{ |n| ['.', '..'].include?(n) }
    @apps = %w(App1 App2)
  end

  def new
  end

  def create
    @app = App.new(app_params)

    respond_to do |format|
      if @app.save
        format.html { redirect_to @brand, notice: 'Brand was successfully created.' }
        format.json { render :show, status: :created, location: @brand }
      else
        format.html { render :new }
        format.json { render json: @brand.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @app = OpenStruct.new(slug: params[:name], name: params[:name].humanize, upstart_file_version: 2)
  end

  private

  def app_params
    params.require(:app).permit(:name)
  end
end
