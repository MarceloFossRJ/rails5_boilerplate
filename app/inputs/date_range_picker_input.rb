class DateRangePickerInput < SimpleForm::Inputs::Base
  def input(wrapper_options)

    text_field_options = input_html_options.with_indifferent_access
    format =  text_field_options.delete(:format)
    #hidden_field_options = text_field_options.dup
    #hidden_field_options[:class] = text_field_options[:class].dup # so they won't work with same array object
    #hidden_field_options[:id] = "#{attribute_name}_hidden"
    text_field_options[:class] << ' daterange'
    text_field_options[:type] = 'text'
    #text_field_options[:value] ||= format_date(value(object), format)
    set_data_option text_field_options, 'date-format', I18n.t(format, scope: [:date, :datepicker], default: :default)
    default_data_option text_field_options, 'behavior', 'daterangepicker'


    template.content_tag(:div, class: 'input-group date', data: { target_input: 'nearest' }, id: "#{object_name}_#{attribute_name}") do
      template.concat @builder.text_field(attribute_name, text_field_options.to_hash)
      #template.concat @builder.hidden_field(attribute_name, hidden_field_options.to_hash)
      template.concat div_button
    end
  end

  def input_html_options
    super.merge({class: 'form-control'})
  end

  def div_button # calendar button
    template.content_tag(:div, class: 'input-group-append', data: {target: "##{object_name}_#{attribute_name}", toggle: 'daterange'} ) do
      template.concat span_table
    end
  end

  def span_table
    template.content_tag(:div, class: 'input-group-text') do
      template.concat icon_table
    end
  end

  def icon_remove
    "<i class='glyphicon glyphicon-remove'></i>".html_safe
  end

  def icon_table
    "<i class='fa fa-calendar'></i>".html_safe
  end

  protected

  def default_data_option(hash, key, value)
    set_data_option(hash,key,value) unless data_option(hash, key)
  end

  def data_option(hash, key)
    hash[:data].try(:[],key) || hash["data-#{key}"]
  end

  def set_data_option(hash, key, value)
    hash[:data].try(:[]=,key,value) || (hash["data-#{key}"] = value)
  end

  def value(object)
    object.send @attribute_name if object
  end

  def format_date(value, format=nil)
    value.try(:strftime, I18n.t(format, scope: [ :date, :formats ], default: :default))
  end
end

