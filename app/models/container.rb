class Container
  include HarbourCrane::DeepStruct

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

  #def id
  #  info.id
  #end

  def self.all
    hashes = Docker::Container.all
    hashes.map { |hash| self.find(hash.id) }
  end

  def self.find id
    c = Docker::Container.get(id)
    hash = c.info.merge({ id: c.id })
    new hash
    #hash.each do |key, value|
      #ap key.underscore
      #o = value.kind_of?(Hash) ? toto(value) : value
      ##instance_variable_set("@#{ key.underscore }", o)
      #send "#{key.underscore }=", o
    #end
  end

  def toto value
    #value.deep_transform_keys{ |key| key.to_s.underscore.to_sym }
    DeepStruct.new(value.deep_transform_keys{ |key| key.to_s.underscore.to_sym })
  end

  def short_id
    #id[0..12]
  end

  def status
    state.status
  end

  #def state
    #info.state
  #end

  def command
    config.cmd.join(' ')
  end

  def ports
    #ap self
    ap network_settings
    network_settings.ports.map do |k, v|
      v.each do |_,v|
        "#{ v.host_ip }:#{ v.host_port }->#{ k }"
      end
    end
  end

  #def names
    #info.names
  #end

  #def image
    #Image.get(info.image)
  #end

  #def info connection = self.connection
    #DeepStruct.new(Docker::Util.parse_json(connection.get('/info')).deep_transform_keys{ |key| key.to_s.underscore })
  #end


end
