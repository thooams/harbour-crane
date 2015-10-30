require 'fileutils'
class App < HcRecord
  include PathHelper
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  include App::State
  include App::Action
  include App::Composer

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
  def path
    HarbourCrane::Application::APP_DIR
  end

  def slug
    name.parameterize
  end

  def upstart_name
    "#{ slug }-#{ id }"
  end

end
