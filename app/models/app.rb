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
  attr_accessor :name, :state, :app, :description, :author, :ports, :image, :virtual_host, :created_at, :compose_file
  attr_reader   :slug

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
    App.new(YAML.load_file("#{ HarbourCrane::Application::APP_DIR }/#{ id }/app.yml"))
  end

  def slug
    name.parameterize
  end

  def running?
    state == RUNNING
  end

  def running!
    update_attribute :state, RUNNING
  end

  def update_attribute att, value
    h = YAML.load_file(app_file(slug))
    h[att.to_s] = value
    update
  end

  def update
    File.open(app_file(slug),'w') do |h|
      h.write self.to_yaml
    end
  end

  def command action
    system("sudo #{ action } #{ slug }")
  end

  def start
    command 'start'
  end

  def stop
    command 'stop'
  end

  def restart
    command 'restart'
  end

  def generate
    if self.valid?
      @app = self

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
    dir_name = compose_app_dir(slug)
    FileUtils::mkdir_p(dir_name) unless File.exists?(dir_name)

    File.open(compose_app_file(slug), 'wb') do |file|
      file.write(compose_file.read)
    end
  end

  # create or upload compose file
  def generate_compose_file
    compose_file.nil? ? create_compose_file : upload_compose_file
  end

  def generate_upstart_file
    dir_name = upstart_app_dir(slug)
    FileUtils::mkdir_p(dir_name) unless File.exists?(dir_name)

    File.open(template_file('upstart.conf.erb'),'r') do |f|
      File.write(upstart_app_file(slug), ERB.new(f.read).result(binding), mode: 'w')
    end

    #FileUtils::cp upstart_app_file(slug), "#{ INIT_DIR }/#{ slug }.conf"
  end

  def create_compose_file
    dir_name = compose_app_dir(slug)
    FileUtils::mkdir_p(dir_name) unless File.exists?(dir_name)

    File.open(template_file('docker-compose.yml.erb'),'r') do |f|
      File.write(compose_app_file(slug), ERB.new(f.read).result(binding), mode: 'w')
    end

    #versioned compose_app_file(slug)
  end

  def generate_app_file
    dir_name = app_dir(slug)
    FileUtils::mkdir_p(dir_name) unless File.exists?(dir_name)

    File.open(template_file('app.yml.erb'),'r') do |f|
      File.write(app_file(slug), ERB.new(f.read).result(binding), mode: 'w')
    end

    #versioned app_file(slug)
  end

  def versioned file
    dir_name = file.split('/')[0..-2].join('/')
    count    = Dir.entries(dir_name).reject{ |n| ['.', '..'].include?(n) }.count
    FileUtils::cp file, "#{ file }.bak-#{ count }"
  end
end
