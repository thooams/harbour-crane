class VolumeInput < SimpleForm::Inputs::Base

  def input(wrapper_options)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    template.content_tag :div, class: "input-group" do
      template.concat template.content_tag(:span, options[:append], class: 'input-group-addon') unless options[:append].nil?
      template.concat @builder.text_field(attribute_name, merged_input_options)
      template.concat template.content_tag(:span, options[:prepend], class: 'input-group-addon') unless options[:prepend].nil?
    end
  end


  def multi_text_field
    UiBibz::Ui::Core:Component.new
  end
end
