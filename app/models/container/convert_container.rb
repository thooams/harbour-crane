class Container::ConvertContainer
  include ActiveModel

  attr_accessor :id, :name, :command, :names, :ports, :image, :created_at, :status

  def initialize cont
    @id         = cont.id
    @info       = cont.info
    @image      = get_image
    @names      = get_names
    @name       = get_name
    @command    = get_command
    @created_at = get_date_time
    @status     = get_status
    @ports      = get_ports
  end

  def attributes
    { id: @id, names: @names, name: @name, ports: @ports, status: @status, command: @command, image: @image, created_at: @created_at }
  end

  private

  def get_names
    names = @info['Names'].blank? ? [@info['Name']] : [@info['Names']].flatten
    names.compact.map{ |n| n[1..-1] }
  end

  def get_status
    @info['State']
  end

  def get_name
    @names.first
  end

  def get_image
    Image.find(@info["ImageID"]) unless @info["ImageID"].nil?
  end

  def get_ports
    @info['Ports'].map{ |p| "#{ p["IP"] }:#{ p['PrivatePort'] }->#{ p['PublicPort']}/#{ p['Type']}" } unless @info["Ports"].nil?
  end

  def get_command
    @info['Command']
  end

  def get_date_time
    Time.utc(@info['Created']).strftime(HarbourCrane::Application::TIME_FORMAT) unless @info['Created'].nil?
  end
end
