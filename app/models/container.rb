class Container
  include HarbourCrane::DeepStruct

  ########  Class methods
  def self.all
    hashes = Docker::Container.all
    hashes.map { |hash| self.find(hash.id) }
  end

  def self.find id
    c = Docker::Container.get(id)
    hash = c.info.merge({ id: c.id })
    new hash
  end

  def self.first
    self.all.first
  end

  ####### Object methods
  def initialize params = {}
    params.each do |key, value|
      o = value.kind_of?(Hash) ? toto(value) : value
      instance_variable_set("@#{ key.to_s.underscore }", o)
      instance_eval "class << self; attr_accessor :#{key.to_s.underscore}; end"
    end
  end

  def proxy?
    'jwilder/nginx-proxy' == image_name
  end

  def administration?
    ['thooams/harbour-crane', 'harbour_crane:latest'].include?(image_name)
  end

  def image_name
    config.image
  end

  def created_at
    created
  end

  def toto value
    DeepStruct.new(value.deep_transform_keys{ |key| key.to_s.underscore.to_sym })
  end

  def short_id
    id[0..12]
  end

  def status
    state.status
  end

  def command
    config.cmd.join(' ')
  end

  def ports
    network_settings.ports.to_h.map do |port|
      if port[1].kind_of?(Array)
        port[1].map do |v|
          "#{ v[:host_ip] }:#{ v[:host_port] }->#{ port[0] }"
        end
      else
        "#{  port[0] }"
      end
    end
  end

  def names
    [name]
  end

  #def image
    #Image.get(info.image)
  #end

end
