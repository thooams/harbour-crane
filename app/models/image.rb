class Image < Docker::Image

  attr_reader :id

  def initialize connection, hash={}
    super
  end

  def proxy?
    names.include?(HarbourCrane::Application::PROXY_IMAGE_NAME)
  end

  def administration?
    names.include?(HarbourCrane::Application::APP_IMAGE_NAME) || names.include?('harbourcrane/harbourcrane')
  end

  def names
    info['RepoTags']
  end

  def names_without_tags
    names.map{ |name| name.split(':').first }
  end

  def created_at
    Time.at(info['Created'])
  end

  def size
    info['VirtualSize']
  end

  def id
    without_hashing_method(info['id'])
  end

  def short_id
    id[0..12]
  end

  def author
    info['Author']
  end

  def destroy
    remove(force: true)
  end

  def without_hashing_method str
    str.split(':').last
  end

  # Class methods # ##############################################################

  def self.find id
    all.select{ |c| without_hashing_method(c.id) == without_hashing_method(id) }.first
  end

  def self.find_by_name name
    all.select{ |c| c.names_without_tags.include?(name) }.first
  end

  def self.pull name, tag = 'latest'
    create('fromImage' => "#{ name }:#{ tag }")
  end

  def self.count
    all.count
  end

  def self.without_hashing_method str
    str.split(':').last
  end

end
