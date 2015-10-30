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
        YAML.load_file(path_file(id))
      rescue
        nil
      end
    end

    private

    def self.dir_entries
      Dir.entries(path).reject{ |n| ['.', '..'].include?(n) }
    end
  end


  # Object Méthods #########################################################
  def persisted?
    false
  end

  def class_name
    self.class.to_s
  end

  def path
    eval "HarbourCrane::Application::#{ class_name.upcase }_DIR }"
  end

  def path_file id
    "#{ path }/#{ id }/#{ class_name }.yml"
  end

  # Update an attribute
  def update_attribute att, value
    send("#{att}=", value)

    update
  end

  # Update complete file app.yml file
  def update
    File.open(path_file(id),'w') do |h|
      h.write self.to_yaml
    end
  end

  def generate_id
    SecureRandom.hex(10)
  end

end
