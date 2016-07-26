class Image
  include ActiveModel

  attr_accessor :id, :name, :tag, :names, :size, :created_at

  def initialize attributes = {}
    attributes.each{ |k,v| instance_variable_set("@#{ k.to_s.underscore }", v) }
  end

  # Class methods  ##############################################################

  def self.all
    Docker::Image.all.map{ |i| self.new(Image::ConvertImage.new(i).attributes) }
  end

  def self.find_by_name name
    all.select{ |c| c.names_without_tags.include?(name) }.first
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

  def self.first
    all.first
  end

  def self.last
    all.last
  end

  # Object methods  ##############################################################

  def names_without_tags
    names.map{ |name| name.split(':').first }
  end

  def short_id
    id[0..12]
  end

  def proxy?
    names.include?(HarbourCrane::Application::PROXY_IMAGE_NAME)
  end

  def administration?
    names.include?(HarbourCrane::Application::APP_IMAGE_NAME) || names.include?('harbourcrane/harbourcrane')
  end

  def destroy
    Docker::Image.get(id).remove(force: true)
  end

  private

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
