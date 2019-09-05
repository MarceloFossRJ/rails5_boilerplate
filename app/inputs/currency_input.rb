class CurrencyInput < SimpleForm::Inputs::Base

  def input(wrapper_options)
    template.content_tag(:div, class: 'input-group', data: { target_input: 'nearest' }, id: "#{object_name}_#{attribute_name}") do
      template.concat div_button
      template.concat @builder.text_field(attribute_name, input_html_options)

    end
  end

  def input_html_options
    super.merge({class: 'form-control'})
  end

  def div_button
    template.content_tag(:div, class: 'input-group-prepend', data: {target: "##{object_name}_#{attribute_name}"} ) do
      template.concat span_table
    end
  end

  def span_table
    template.content_tag(:div, class: 'input-group-text') do
      template.concat icon_table
    end
  end

  def icon_table
    "$".html_safe
  end
end

