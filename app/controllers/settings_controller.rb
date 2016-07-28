require 'rake'

Rake::Task.clear # necessary to avoid tasks being loaded several times in dev mode
HarbourCrane::Application.load_tasks

class SettingsController < ApplicationController
  def index
  end

  def create_proxy
    App.create_and_start_proxy
    respond_to do |format|
      format.html { redirect_to settings_index_url, notice: 'Proxy was successfully created.' }
      format.json { head :no_content }
    end
  end

  def destroy_proxy
    App.destroy_proxy
    respond_to do |format|
      format.html { redirect_to settings_index_url, notice: 'Proxy was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
end
