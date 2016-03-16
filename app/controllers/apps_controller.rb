require 'yaml'
class AppsController < ApplicationController

  before_action :set_app, only: [:show, :start, :edit, :stop, :destroy, :restart]

  def index
    @apps = App.all
  end

  def new
    @app = App.new
  end

  def create
    @app = App.new(app_params)

    respond_to do |format|
      if @app.save
        format.html { message("created") }
        format.json { render :show, status: :created, location: @app }
      else
        format.html { render :new, notice: @app.errors.full_messages.to_sentence }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @app = OpenStruct.new(slug: params[:name], name: params[:id].humanize, upstart_file_version: 2)
    @appname = App.find(params[:id]).name.titleize
  end

  def show
    @app = App.find(params[:id])
  end

  def start
    respond_to do |format|
      if @app.start
        format.html { message("started") }
      else
        format.html { message(@app.errors.full_messages.to_sentence) }
      end
    end
  end

  def stop
    @app.stop
    respond_to do |format|
      format.html { message("stopped") }
    end
  end

  def restart
    @app.restart
    respond_to do |format|
      format.html { message("restarted") }
    end
  end

  def destroy
    @app.destroy
    respond_to do |format|
      format.html { message("deleted") }
    end
  end

  private

  def set_app
    @app = App.find(params[:id])
  end

  def app_params
    params.require(:app).permit(:name, :description, :slug, :author, :image, :compose_file, :ports, :virtual_host)
  end

  def message mymessage
    # Si mymessage ne contient qu'un mot c'est un message success
    # Sinon c'est un message d'erreur complet
    ((mymessage.scan(/\w+/).size) == 1) ? (redirect_to apps_path, notice: "App was successfully #{mymessage}.") : (redirect_to apps_path, notice: mymessage)
  end
end
