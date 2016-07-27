require 'fileutils'
module App::Composer
  include PathHelper

  private

  def upload_compose_file
    init_dir

    File.open(compose_app_file(slug), 'wb') do |file|
      file.write(compose_file.read)
    end
  end

  # create or upload compose file
  def generate_compose_file
    compose_file.nil? ? create_compose_file : upload_compose_file
  end

  def create_compose_file
    @app = self
    init_dir

    File.open(template_file('docker-compose.yml.erb'),'r') do |f|
      File.write(compose_app_file(slug), ERB.new(f.read, nil, '-').result(binding), mode: 'w')
    end

    #puts File.read(compose_app_file(@app.id))

    #versioned compose_app_file(id)
  end

  def init_dir
    dir_name = compose_app_dir(slug)
    File.exists?(dir_name) ? destroy_compose_file : FileUtils::mkdir_p(dir_name)
  end

  def destroy_file path_file
    File.delete(path_file) if File.exists?(path_file)
  end

  def destroy_compose_file
    destroy_file compose_app_file(slug)
  end

  def versioned file
    dir_name = file.split('/')[0..-2].join('/')
    count    = Dir.entries(dir_name).reject{ |n| ['.', '..'].include?(n) }.count
    FileUtils::cp file, "#{ file }.bak-#{ count }"
  end

end
