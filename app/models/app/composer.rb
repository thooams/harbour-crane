module App::Composer

  def generate
    if self.valid?
      @app    = self
      @app.id = generate_id if @app.id.nil?

      # generate upstart file and bak
      generate_upstart_file

      # generate compose file and bak
      generate_compose_file

      # generate app conf
      generate_app_file

      true
    else
      false
    end
  end


  private

  def app_file id
    "#{ HarbourCrane::Application::APP_DIR }/#{ id }/app.yml"
  end

  def upload_compose_file
    dir_name = compose_app_dir(@app.id)
    FileUtils::mkdir_p(dir_name) unless File.exists?(dir_name)

    File.open(compose_app_file(id), 'wb') do |file|
      file.write(compose_file.read)
    end
  end

  # create or upload compose file
  def generate_compose_file
    compose_file.nil? ? create_compose_file : upload_compose_file
  end

  def generate_upstart_file
    dir_name = upstart_app_dir(id)
    FileUtils::mkdir_p(dir_name) unless File.exists?(dir_name)

    File.open(template_file('upstart.conf.erb'),'r') do |f|
      File.write(upstart_app_file(@app.id), ERB.new(f.read).result(binding), mode: 'w')
    end

    FileUtils::cp upstart_app_file(@app.id), init_upstart_file(@app.upstart_name)
  end

  def create_compose_file
    dir_name = compose_app_dir(@app.id)
    FileUtils::mkdir_p(dir_name) unless File.exists?(dir_name)

    ap @app
    ap compose_app_file(@app.id)
    File.open(template_file('docker-compose.yml.erb'),'r') do |f|
      ap f.read
      ap ERB.new(f.read, nil, '-').result(binding)
      File.write(compose_app_file(@app.id), ERB.new(f.read, nil, '-').result(binding), mode: 'w')
    end

    puts File.read(compose_app_file(@app.id))

    #versioned compose_app_file(id)
  end

  def generate_app_file
    dir_name = app_dir(@app.id)
    FileUtils::mkdir_p(dir_name) unless File.exists?(dir_name)

    File.open(template_file('app.yml.erb'),'r') do |f|
      File.write(app_file(@app.id), ERB.new(f.read).result(binding), mode: 'w')
    end

    #versioned app_file(id)
  end

  def destroy_app_file
    FileUtils.remove_dir(app_dir(id))
  end

  def destroy_file path_file
    File.delete(path_file) if File.exists?(path_file)
  end

  def destroy_upstart_file
    stop
    destroy_file init_upstart_file(upstart_name)
  end

  def destroy_compose_file
    destroy_file compose_app_file(id)
  end

  def versioned file
    dir_name = file.split('/')[0..-2].join('/')
    count    = Dir.entries(dir_name).reject{ |n| ['.', '..'].include?(n) }.count
    FileUtils::cp file, "#{ file }.bak-#{ count }"
  end

end
