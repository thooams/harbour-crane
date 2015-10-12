class Image < Docker::Image

  def initialize connection, hash={}
    super
  end

  def proxy?
    names.include?('jwilder/nginx-proxy:latest')
  end

  def administration?
    names.include?('harbour_crane:latest') || names.include?('harbourcrane/harbourcrane')
  end

  def names
    info['RepoTags']
  end

  def created_at
    Time.at(info['Created'])
  end

  def size
    info['VirtualSize']
  end

  def id
    info['id']
  end

  def short_id
    id[0..12]
  end

  def author
    info['Author']
  end

  def self.find id
    all.reject{ |c| c.id != id }.first
  end

end
