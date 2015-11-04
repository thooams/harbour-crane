class Container < Docker::Container

  def initialize connection, hash={}
    super
  end

  def proxy?
    'jwilder/nginx-proxy' == image_name
  end

  def administration?
    ['thooams/harbour-crane', 'harbour_crane:latest'].include?(image_name)
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

  def state
    info['State']
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
    Image.get(info['Image'])
  end

  def infos
    if @infos.nil?
      @infos = info.deep_transform_keys{ |key| key.to_s.underscore }
    end
    @infos
  end

  private

  def build_json hash
    hash.map do |k, v|
      if v.kind_of? Hash
        infos = infos.merge(Hash[sanitize_json(k), build_json(v, infos)])
      else
        infos = infos.merge(Hash[sanitize_json(k), v])
      end
    end
    infos
  end

  def sanitize_json name
    name.underscore
  end

end
