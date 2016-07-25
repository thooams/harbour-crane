class Image
  include ActiveModel
  #extend ActiveModel::Naming

  attr_accessor :id, :name, :tag, :names, :size, :created_at

  def initialize image = nil
    unless image.nil?
      @id         = without_hashing_method(image.id)
      @names      = image.info['RepoTags']
      @name       = get_name
      @tag        = get_tag
      @info       = image.info
      @size       = image.info['VirtualSize']
      @created_at = get_date_time
    end
  end


  # Class methods  ##############################################################

  def self.all
    Docker::Image.all.map{ |i| self.new(i) }
  end

  def self.find_by_name name
    all.select{ |c| c.names_without_tags.include?(name) }.first
  end

  def self.find id
    all.select{ |c| c.id == without_hashing_method(id) }.first
  end

  # Return Image object
  def self.pull args
    self.new Docker::Image.create('fromImage' => "#{ args[:name] }:#{ args[:tag].blank? ? 'latest' : args[:tag] }")
  end

  def self.count
    Docker::Image.all.count
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

  def author
    @info['Author']
  end

  def destroy
    Docker::Image.get(id).remove(force: true)
  end

  private

  def self.without_hashing_method str
    str.split(':').last
  end

  def get_date_time
    Time.utc(@info['Created']).strftime(HarbourCrane::Application::TIME_FORMAT)
  end

  def without_hashing_method str
    str.split(':').last
  end

  def get_name
    @names.first.split(':').first
  end

  def get_tag
    @names.first.split(':').last
  end

end
