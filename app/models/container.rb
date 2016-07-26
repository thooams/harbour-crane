class Container
  include ActiveModel

  attr_accessor :id, :name, :command, :names, :ports, :image, :created_at, :status

  def initialize attributes = {}
    attributes.each{ |k,v| instance_variable_set("@#{ k.to_s.underscore }", v) }
  end

  # Class methods  ##############################################################

  def self.all
    Docker::Container.all(all: true).map{ |i| self.new(Container::ConvertContainer.new(i).attributes) }
  end

  def self.find id
    new Container::ConvertContainer.new(Docker::Container.get(id)).attributes
  end

  def self.find_by_name name
    all.select{ |c| c.names.include?(name) }.first
  end

  def self.first
    all.first
  end

  def self.run image_name, args
    create(image_name, args).start
  end

  def self.create image_name, args
    arguments = { 'Image': image_name }
    arguments = arguments.merge({ 'Cmd'  => args[:cmd] })  if args[:cmd]
    arguments = arguments.merge({ 'name' => args[:name] }) if args[:name]
    new Container::ConvertContainer.new(Docker::Container.create(arguments)).attributes
  end

  # Object methods  ##############################################################

  def destroy force = false
    Docker::Container.get(self.id).delete(force: force)
  end

  def start
    Docker::Container.get(id).start
  end

  def stop
    Docker::Container.get(id).stop
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
    ap exited?
    exited? || stopped?
  end

  def can_stop?
    started?
  end

end
