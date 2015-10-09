class ImagePresenter < ApplicationPresenter

  def initialize images
    @images = images
  end

  def images
    @images.map{ |image| format_image(image) }
  end

  def image
    format_image @images
  end

  private

  def format_image image
    OpenStruct.new({
      id:          format_id(image),
      created_at:  format_created_at(image),
      size:        format_size(image),
      names:       format_image_name(image),
      infos:       image
    })
  end

  def format_size image
    number_to_human_size image.size
  end

  def format_id image
    content_tag :span, image.short_id, title: image.id
  end

  def format_image_name image
    if image.proxy?
      "#{ image.names.join(', ') } #{ etiquette('Proxy', state: :danger) }".html_safe
    elsif image.administration?
      "#{ image.names.join(', ') } #{ etiquette('Admin', state: :primary) }".html_safe
    else
      image.names.join(', ')
    end
  end

  def format_created_at image
    image.created_at
  end

end
