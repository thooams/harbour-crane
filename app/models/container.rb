class Container
  include ActiveModel

  attr_accessor :id, :name, :command, :names, :ports, :image, :created_at, :status

  def initialize cont = nil
    unless cont.nil?
      if cont.class.to_s == "Docker::Container"
        @id         = cont.id
        @info       = cont.info
        @image      = get_image
        @names      = get_names
        @name       = get_name
        @created_at = get_date_time
        @status     = get_status
        @ports      = get_ports
      else
        cont.each{ |k,v| instance_variable_set("@#{ k.to_s.underscore }", v) }
      end
    end
  end

  # Class methods  ##############################################################

  def self.all
    Docker::Container.all(all: true).map{ |i| self.new(i) }
  end

  def self.find id
    self.new Docker::Container.get(id)
  end

  def self.find_by_name name
    self.all.select{ |c| c.names.include?(name) }.first
  end

  def self.first
    self.all.first
  end

  def self.run image_name, args
    self.create(image_name, args).start
  end

  def self.create image_name, args
    arguments = { 'Image': image_name }
    arguments = arguments.merge({ 'Cmd'  => args[:cmd] })  if args[:cmd]
    arguments = arguments.merge({ 'name' => args[:name] }) if args[:name]
    self.new Docker::Container.create(arguments)
  end

  # Object methods  ##############################################################

  def destroy
    Docker::Container.get(self.id).delete(force: true)
  end

  def start
    Docker::Container.get(id).start
  end

  def short_id
    id[0..12]
  end

  #def ports
  #  network_settings.ports.to_h.map do |port|
  #    if port[1].kind_of?(Array)
  #      port[1].map do |v|
  #        "#{ v[:host_ip] }:#{ v[:host_port] }->#{ port[0] }"
  #      end
  #    else
  #      "#{  port[0] }"
  #    end
  #  end
  #end

  def get_names info
    names = info['Names'].blank? ? [info['Name']] : [info['Names']].flatten
    names.compact.map{ |n| n[1..-1] }
  end

  def get_status info
    info[:state]
  end

  def get_name
    @names.first
  end

  def get_image info
    ap Image.find(info["ImageID"]) unless info["ImageID"].nil?
    Image.find(info["ImageID"]) unless info["ImageID"].nil?
  end

  def get_ports info
    info['Ports'].map{ |p| p.values.join } unless info["Ports"].nil?
  end

  def get_date_time info
    Time.utc(info['Created']).strftime(HarbourCrane::Application::TIME_FORMAT) unless info['Created'].nil?
  end
end
