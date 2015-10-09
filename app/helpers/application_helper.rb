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

end
