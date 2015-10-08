module ApplicationHelper

  def glyph_and_text glyph_args, text
    "#{ glyph glyph_args } #{ text }".html_safe
  end

  def version_array array
    array.map do |name|
      num = name.split('.bak-').last
      ["version #{ num }", num]
    end
  end

  def display_image_name name
     case name
     when 'jwilder/nginx-proxy'
       "#{ name } #{ etiquette('Proxy', state: :danger) }".html_safe
     when 'thooams/harbour-crane'
      "#{ name } #{ etiquette('Admin', state: :primary) }".html_safe
     else
       name
     end
  end

  def is_proxy? container
    'jwilder/nginx-proxy' == container.info["Image"]
  end

  def display_ports_info ports
    ports.map do |port|
      "#{ port['IP'] }:#{ port['PrivatePort']}->#{ port['PublicPort'] }/#{ port['Type']}"
    end.join('<br/>').html_safe
  end
end
