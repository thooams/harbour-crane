class App < ActiveRecord::Base
  include App::AASM
  include App::Composer

  #include App::Record

  # Scopes

  # Callbacks
  after_create   :generate_compose_file
  before_destroy :destroy_compose_file

  # Constants
  GLYPH = HarbourCrane::Application::Glyph::APP

  # Attr_accessor
  attr_accessor :compose_file

  # Associations

  # Validations
  validates :name, :slug, :ports, :virtual_host, :image, presence: true
  validates :slug, uniqueness: true

  # Delegation

  # Methods

end
