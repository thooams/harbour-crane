require 'fileutils'
class App
  include ApplicationHelper
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
  GLYPH = 'cube'

  # Attr_accessor
  attr_accessor :name, :description, :author, :ports, :image, :virtual_host
  attr_reader   :slug

  # Associations

  # Validations
  validates :name, presence: true

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
    @app = self

    # generate upstart file and bak
    generate_upstart_file

    # generate compose file and bak
    generate_compose_file

    # generate app conf
    generate_app_file

    # create volumes
    #generate_volumes

    true
  end

  private

  def generate_upstart_file
    dir_name = upstart_app_dir(slug)
    FileUtils::mkdir_p(dir_name) unless File.exists?(dir_name)

    File.open("public/templates/upstart.conf.erb",'r') do |f|
      File.write(upstart_app_file(slug), ERB.new(f.read).result(binding), mode: 'w')
    end
  end

  def generate_compose_file
    dir_name = compose_app_dir(slug)
    FileUtils::mkdir_p(dir_name) unless File.exists?(dir_name)

    File.open("public/templates/docker-compose.yml.erb",'r') do |f|
      File.write(compose_app_file(slug), ERB.new(f.read).result(binding), mode: 'w')
    end
  end

  def generate_app_file
    dir_name = app_dir(slug)
    FileUtils::mkdir_p(dir_name) unless File.exists?(dir_name)

    File.open("public/templates/app.yml.erb",'r') do |f|
      File.write(app_file(slug), ERB.new(f.read).result(binding), mode: 'w')
    end
  end

  def generate_volumes
    ["/srv/docker/#{ @app.slug }/vol", "/srv/docker/#{ @app.slug }/log"].each do |dir_name|
      FileUtils::mkdir_p(dir_name) unless File.exists?(dir_name)
    end
  end
end
