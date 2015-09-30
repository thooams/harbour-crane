module ApplicationHelper

  def glyph_and_text glyph_args, text
    "#{ glyph glyph_args } #{ text }".html_safe
  end

end
