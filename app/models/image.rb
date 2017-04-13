class Image
  include ActiveModel::Model

  attr_accessor :id, :name, :tag, :names, :size, :created_at

  def initialize attributes = {}
    attributes.each{ |k,v| instance_variable_set("@#{ k.to_s.underscore }", v) }
  end

  # Class methods  ##############################################################

  def self.all
    Docker::Image.all.map{ |i| self.new(Image::ConvertImage.new(i).attributes) }
  end

  # Find by name alone or with tag
  #  => hello-world or hello-world:beta
  def self.find_by_name name
    name_with_tag = name.split(':').count > 1 ? name : "#{ name }:latest"
    all.select{ |c| c.names.include?(name_with_tag) }.first
  end

  def self.find id
    all.select{ |c| c.id == without_hashing_method(id) }.first
  end

  # Return Image object
  def self.pull args
    new(Image::ConvertImage.new(Docker::Image.create('fromImage' => image_with_tag(args))).attributes)
  end

  def self.count
    Docker::Image.all.count
  end

  def self.first_or_create args
    raise 'name argument must be present.' if args[:name].nil?
    img = Image.find_by_name(args[:name])
    img.nil? ? pull(args) : img
  end

  def self.first
    all.first
  end

  def self.last
    all.last
  end

  # Object methods  ##############################################################

  def short_id
    id[0..12]
  end

  def proxy?
    names.include?(HarbourCrane::Application::PROXY_IMAGE_NAME)
  end

  def administration?
    names_without_tag.include?(HarbourCrane::Application::APP_IMAGE_NAME)
  end

  def protected?
    proxy? || administration?
  end

  def used?
    !names.select{ |name| Container.find_by_image(name) }.first.nil?
  end

  # Return Error
  def destroy force = false
    begin
      Docker::Image.get(id).remove(force: force)
    rescue => e
      errors.add e.message
    end
  end

  # Return Array with errors
  def self.destroy_all *ids
    ids.flatten.map do |id|
      image = self.find(id)
      unless image.nil?
        image.destroy
        image.errors.empty? ? nil : image.errors.full_messages.to_sentence
      else
        "Image #{id} not found"
      end
    end.compact
  end

  private

  def names_without_tag
    names.map{ |name| name.split(':')[0] }
  end

  def self.without_hashing_method str
    str.split(':').last
  end

  def without_hashing_method str
    str.split(':').last
  end

  def self.image_with_tag args
    "#{ args[:name] }:#{ args[:tag].blank? ? 'latest' : args[:tag] }"
  end

  self.singleton_class.send(:alias_method, :create, :pull)

end
