require 'yaml'
class AppsController < ApplicationController

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

  private

  def app_params
    params.require(:app).permit(:name, :description, :author, :image, :compose_file, :ports, :virtual_host)
  end
end
