require 'fileutils'
class App
  include ApplicationHelper
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

  private

  def generate_upstart_file
    ap name
    dir_name = upstart_app_dir(slug)
    FileUtils::mkdir_p(dir_name) unless File.exists?(dir_name)
    app = self
    File.open("public/templates/upstart.conf.erb",'r') do |f|
      ap ERB.new(f.read, 0, "", "app").result
      File.write(upstart_app_file(slug), ERB.new(f.read, 0, "", "app").result, mode: 'a')
    end
  end
end
