class ProxyController < ApplicationController
  def index
    @versions = Dir.entries(nginx_template_dir).map do |file_name|
      file = file_name.split('nginx-')
      if file.size > 1
        number = file[1].split('.')[0]
        ["Version #{ number }", number]
      else
        nil
      end
    end.compact
    @last_version = @versions.last.first
    @version   = params[:version] || @versions.last.last
    @file_name = params[:version].nil? ? "nginx.tmpl" : "nginx-#{ params[:version] }.tmpl"
  end
end
