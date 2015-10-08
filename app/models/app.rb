require 'fileutils'
class App
  include PathHelper
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  # Scopes

  # Constants
  GLYPH = HarbourCrane::Application::Glyph::APP

  # Attr_accessor
  attr_accessor :name, :state, :description, :author, :ports, :image, :virtual_host, :created_at, :compose_file
  attr_reader   :slug

  # Associations

  # Validations
  validates :name, :ports, :virtual_host, :image, presence: true

  # Delegation

  # Methods
  # for non active record
  def persisted?
    false
  end

  def slug
    name.parameterize
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

    versioned compose_app_file(slug)
  end

  def generate_app_file
    dir_name = app_dir(slug)
    FileUtils::mkdir_p(dir_name) unless File.exists?(dir_name)

    File.open(template_file('app.yml.erb'),'r') do |f|
      File.write(app_file(slug), ERB.new(f.read).result(binding), mode: 'w')
    end

    versioned app_file(slug)
  end

  def versioned file
    dir_name = file.split('/')[0..-2].join('/')
    count    = Dir.entries(dir_name).reject{ |n| ['.', '..'].include?(n) }.count
    FileUtils::cp file, "#{ file }.bak-#{ count }"
  end
end
