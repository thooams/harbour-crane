require 'fileutils'
class App
  include PathHelper
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  RUNNING = :running
  STOPPED = :stopped
  STATES  = [RUNNING, STOPPED]

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  # Scopes

  # Constants
  GLYPH = HarbourCrane::Application::Glyph::APP

  # Attr_accessor
  attr_accessor :name, :id, :state, :app, :description, :author, :ports, :image, :virtual_host, :created_at, :compose_file, :volumes
  attr_reader   :slug, :upstart_name

  # Associations

  # Validations
  validates :name, :ports, :virtual_host, :image, presence: true
  #validates :name, uniqueness: true

  # Delegation

  # Methods
  # for non active record
  def persisted?
    false
  end

  def self.all
    Dir.entries(HarbourCrane::Application::APP_DIR).reject{ |n| ['.', '..'].include?(n) }.map do |name|
      self.find name
    end
  end

  def self.find id
    begin
      App.new(YAML.load_file("#{ HarbourCrane::Application::APP_DIR }/#{ id }/app.yml"))
    rescue
      nil
    end
  end

  def slug
    name.parameterize
  end

  def upstart_name
    "#{ slug }-#{ id }"
  end

  def running?
    state == RUNNING
  end

  # Force state in running
  def running!
    update_attribute :state, RUNNING
  end

  # Update an attribute
  def update_attribute att, value
    h = YAML.load_file(app_file(slug))
    h[att.to_s] = value
    update
  end

  # Update complete file app.yml file
  def update
    File.open(app_file(slug),'w') do |h|
      h.write self.to_yaml
    end
  end

  def start
    #command 'start'
    fu = "COMPOSE_FILE=#{ compose_app_file(id) } /usr/local/bin/docker-compose up"
    ap fu
    system(fu)
  end

  def stop
    command 'stop'
  end

  def restart
    command 'restart'
  end

  def destroy
    destroy_upstart_file
    destroy_compose_file
    destroy_app_file
  end

  def generate_id
    SecureRandom.hex(10)
  end

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

  def command action
    func = "#{ action } #{ upstart_name }"
    ap func
    #system("sudo #{ action } #{ upstart_name }")
    if system(func)
      ap 'ca fonctionne'
      true
    else
      ap 'ca fonctionne po !!'
      errors.add(:system, "Command system '#{ func }' fail")
    end
  end

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

    File.open(template_file('docker-compose.yml.erb'),'r') do |f|
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
