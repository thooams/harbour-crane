require 'fileutils'
class App
  include PathHelper
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  include App::Record
  include App::Action
  include App::Composer

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

end
