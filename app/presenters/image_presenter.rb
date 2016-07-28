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
      display_id:  format_id(image),
      created_at:  format_created_at(image),
      size:        format_size(image),
      names:       format_image_name(image),
      image:       image
    })
  end

  def format_size image
    number_to_human_size image.size
  end

  def format_id image
    content_tag :span, image.short_id, title: image.id
  end

  def format_image_name image
    image_name = [image.names]
    image_name << etiquette('Proxy', status: :danger)  if image.proxy?
    image_name << etiquette('Admin', status: :success) if image.administration?
    image_name << etiquette("Used",  status: :default) if image.used?
    image_name.join(' ').html_safe
  end

  def format_created_at image
    image.created_at
  end

end
