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

  def active_link name
    [*name].include?(params[:controller]) ? :active : nil
  end

  def bootstrap_status_for flash_type
    { success: :success, error: :danger, alert: :warning, notice: :info }[flash_type.to_sym] || flash_type.to_s
  end

  def bootstrap_icon_for flash_type
    { success: "check-circle", error: "minus-circle", alert: "exclamation-triangle", notice: "check-circle" }[flash_type.to_sym] || "question-circle"
  end

end
