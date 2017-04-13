class Container
  include ActiveModel::Model

  attr_accessor :id, :name, :command, :names, :ports, :image, :created_at, :status

  def initialize attributes = {}
    attributes.each{ |k,v| instance_variable_set("@#{ k.to_s.underscore }", v) }
  end

  # Class methods  ##############################################################

  def self.all
    Docker::Container.all(all: true).map{ |i| new(Container::ConvertContainer.new(i).attributes) }
  end

  def self.find id
    new Container::ConvertContainer.new(Docker::Container.get(id)).attributes
  end

  def self.find_by_name name
    all.select{ |c| c.names.include?(name) }.first
  end

  def self.find_by_image name
    all.select{ |c| c.image.names.include?(name) }.first
  end

  def self.first
    all.first
  end

  def self.first_or_create args
    cont = find_by_name args[:name]
    cont.nil? ? create(args) : cont
  end

  def self.run args
    cont = create(args)
    cont.start
  end

  def self.create args
    raise 'image argument must be present.' if args[:image].nil?
    arguments = { 'Image' => args[:image] }
    arguments = arguments.merge({ 'Cmd'  => args[:cmd] })  unless args[:cmd].nil?
    arguments = arguments.merge({ 'name' => args[:name] }) unless args[:name].nil?
    docker_container_tmp = Docker::Container.create(arguments)
    docker_container     = Docker::Container.get(docker_container_tmp.id)
    new Container::ConvertContainer.new(docker_container).attributes
  end

  def self.destroy_unused
    all.each{ |container| container.destroy if %w(exited started).include?(container.status) }
  end

  # Object methods  ##############################################################

  def destroy force = false
    Docker::Container.get(self.id).delete(force: force)
  end

  def start
    Docker::Container.get(id).start
    self
  end

  def stop
    Docker::Container.get(id).stop
    self
  end

  def short_id
    id[0..12]
  end


  #### STATUS

  def started?
    status == 'running'
  end

  def exited?
    status == 'exited'
  end

  def stopped?
    status == 'stopped'
  end

  def can_start?
    exited? || stopped?
  end

  def can_stop?
    started?
  end

end
