class App
  # Scopes

  # Constants
  GLYPH = 'cube'

  # Attr_accessor
  attr_accessor :name, :description, :author
  attr_reader   :slug

  # Associations

  # Validations

  # Delegation

  # Methods
  def slug
    name.parameterize
  end

  def generate
    ap 'ariustnau'
    # generate upstart file and bak
    generate_upstart_file
    # generate compose file and bak
    # create volumes
  end

  def generate_upstart_file
    File.open("/templates/upstart.conf.erb",'r') do |f|
      File.write(upstart_app_dir(name), f, mode: 'a')
    end
  end
end
