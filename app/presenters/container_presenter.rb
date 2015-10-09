class ContainerPresenter < ApplicationPresenter

  def initialize containers
    @containers = containers
  end

  def render
    @containers.map{ |container| format_container(container) }
  end

  private

  def format_container container
    OpenStruct.new({
      id:          format_id(container),
      image_name:  format_image_name(container),
      created_at:  format_created_at(container),
      command:     container.command,
      status:      container.status,
      ports:       format_ports(container),
      names:       format_names(container),
      infos:       container
    })
  end

  def format_id container
    content_tag :span, container.short_id, title: container.id
  end

  def format_image_name container
    if container.proxy?
      "#{ container.image_name } #{ etiquette('Proxy', state: :danger) }".html_safe
    elsif container.administration?
      "#{ container.image_name } #{ etiquette('Admin', state: :primary) }".html_safe
    else
      container.image_name
    end
  end

  def format_created_at container
    container.created_at
  end

  def format_ports container
    container.ports.map do |port|
      "#{ port['IP'] }:#{ port['PrivatePort']}->#{ port['PublicPort'] }/#{ port['Type']}"
    end.join('<br/>').html_safe
  end

  def format_names container
    container.names.join('<br/>').html_safe
  end

end
