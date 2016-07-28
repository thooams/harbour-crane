class App < ApplicationRecord
  include App::Aasm
  include App::Composer

  #include App::Record

  # Scopes

  # Callbacks
  after_create      :generate_compose_file
  before_validation :generate_slug
  before_destroy    :destroy_compose_file

  # Constants
  GLYPH = HarbourCrane::Application::Glyph::APP
  enum category: {
    admin: 0,
    proxy: 1,
    web:   2
  }

  # Attr_accessor
  attr_accessor :compose_file, :volume_1, :volume_2

  # Associations

  # Validations
  validates :name, :slug, :ports, :virtual_host, :image, presence: true
  validates :slug, uniqueness: true

  # Delegation

  # Methods

  def proxy?
    slug == HarbourCrane::Application::PROXY_NAME.parameterize
  end

  private

  def generate_slug
    self.slug = name.parameterize if slug.blank?
  end

end
