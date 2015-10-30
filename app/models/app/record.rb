require 'active_support/concern'
module App::Record
  extend ActiveSupport::Concern

  # Class Méthods #########################################################
  included do

    def self.all
      dir_entries.map do |name|
        self.find name
      end
    end

    def self.find id
      begin
        YAML.load_file("#{ HarbourCrane::Application::APP_DIR }/#{ id }/app.yml")
      rescue
        nil
      end
    end

    private

    def self.dir_entries
      Dir.entries(HarbourCrane::Application::APP_DIR).reject{ |n| ['.', '..'].include?(n) }
    end
  end


  # Object Méthods #########################################################
  def persisted?
    false
  end

  # Update an attribute
  def update_attribute att, value
    send("#{att}=", value)

    update
  end

  # Update complete file app.yml file
  def update
    File.open(app_file(id),'w') do |h|
      h.write self.to_yaml
    end
  end

  def generate_id
    SecureRandom.hex(10)
  end

  def app_file id
    "#{ HarbourCrane::Application::APP_DIR }/#{ id }/app.yml"
  end

end
