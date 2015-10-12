require 'yaml'
class AppsController < ApplicationController

  before_action :set_app, only: [:show, :start, :stop, :restart]

  def index
    @apps = App.all
  end

  def new
    @app = App.new
  end

  def create
    @app = App.new(app_params)

    respond_to do |format|
      if @app.generate
        format.html { redirect_to @app, notice: 'Brand was successfully created.' }
        format.json { render :show, status: :created, location: @app }
      else
        format.html { render :new }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @app = OpenStruct.new(slug: params[:name], name: params[:name].humanize, upstart_file_version: 2)
  end

  def show
    @app = App.find(params[:name])
  end

  def start
    @app.start
    respond_to do |format|
      format.html { redirect_to apps_path, notice: 'App was successfully started.' }
    end
  end

  def stop
    @app.stop
    respond_to do |format|
      format.html { redirect_to apps_path, notice: 'App was successfully stopped.' }
    end
  end

  def restart
    @app.restart
    respond_to do |format|
      format.html { redirect_to apps_path, notice: 'App was successfully restarted.' }
    end
  end

  private

  def app_params
    params.require(:app).permit(:name, :description, :author, :image, :compose_file, :ports, :virtual_host)
  end
end
