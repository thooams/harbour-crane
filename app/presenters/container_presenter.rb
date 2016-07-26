class ContainerPresenter < ApplicationPresenter

  def initialize objs
    @containers = objs
  end

  def containers
    @containers.map{ |c| format_container(c) }
  end

  def container
    format_container @containers
  end

  private

  def format_container obj
    OpenStruct.new({
      display_id:    format_id(obj),
      display_image: format_image_name(obj),
      created_at:    obj.created_at,
      command:       obj.command,
      status:        obj.status,
      ports:         format_ports(obj),
      image:         obj.image,
      container:     obj,
      names:         format_names(obj)
    })
  end

  def format_id obj
    content_tag :span, obj.short_id, title: obj.id
  end

  def format_image_name obj
    if obj.image.proxy?
      "#{ obj.image.names.join(', ') } #{ etiquette('Proxy', state: :danger) }".html_safe
    elsif obj.image.administration?
      "#{ obj.image.names.join(', ') } #{ etiquette('Admin', state: :primary) }".html_safe
    else
      obj.image.names.join(', ')
    end
  end

  def format_created_at obj
    obj.created_at
  end

  def format_ports obj
    obj.ports.join('<br/>').html_safe
  end

  def format_names obj
    if obj.names.count > 2
      obj_names = obj.names.join('; ')
      content_tag :span, obj.names[0..1].push('...').join('<br/>').html_safe, title: obj_names
    else
      obj.names.join('<br/>').html_safe
    end
  end

end
