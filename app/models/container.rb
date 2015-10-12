class Container < Docker::Container

  def initialize connection, hash={}
    super
  end

  def proxy?
    'jwilder/nginx-proxy' == image_name
  end

  def administration?
    'thooams/harbour-crane' == image_name
  end

  def image_name
    info['Image']
  end

  def created_at
    Time.at(info['Created'])
  end

  def id
    info['id']
  end

  def short_id
    id[0..12]
  end

  def status
    info['Status']
  end

  def command
    info['Command']
  end

  def ports
    info['Ports']
  end

  def names
    info['Names']
  end

  def image
    Docker::Image.get(info['Image'])
  end

end
