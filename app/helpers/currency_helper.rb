module CurrencyHelper
  #helper to list all currencies with no preferences
  def all_currency_codes
    currencies = []
    Money::Currency.table.values.each do |currency|
      currencies = currencies + [[currency[:name] + ' (' + currency[:iso_code] + ')', currency[:iso_code]]]
    end
    currencies
  end

  #helper to list all currencies with preferences
  def currency_codes
    currencies = []
    StandardCurrency.all.order(iso_code: :asc).each do |mp|
      Money::Currency.table.values.each do |c|
        if c[:iso_code] == mp[:iso_code]
          currencies = currencies + [[c[:name] + ' (' + c[:iso_code] + ')', c[:iso_code]]]
        end
      end
    end

    Money::Currency.table.values.each do |currency|
      currencies = currencies + [[currency[:name] + ' (' + currency[:iso_code] + ')', currency[:iso_code]]]
    end
    currencies
  end
  
  def currency_input(model,
                     field_name="currency",
                     field_value=[],
                     required=false,
                     multiselect=false,
                     include_blank=true)

    model = model.downcase
    out  = "<div class='form-group select #{ "required" if required }'>"
    out << "<label class='select required' for='#{model}_#{field_name}'>#{field_name.humanize} #{ "<abbr title='required'>*</abbr>" if required}</label>"
    out << "<select class='form-control select required select-2' name='#{model}[#{field_name}]#{"[]" if multiselect }' id='#{model}_#{field_name}' #{"multiple='multiple'" if multiselect}>"
    out << "<option value=''>&nbsp;</option>" if include_blank
    currencies = Money::Currency.table.values
    #default_values.each do |c|
    #  curr =  currencies.select { |v| v[:iso_code] == c }
    #  out << "<option value='#{curr[:iso_code]}'>#{curr[:symbol]} - #{curr[:name]} (#{curr[:iso_code]})</option>"
    #  currencies.delete_if { |v| v[:iso_code] == c }
    #end
    currencies.each do |currency|
      out << "<option value='#{currency[:iso_code]}' #{"selected" if field_value.include? currency[:iso_code]}>"
      out << "#{currency[:symbol]} - #{currency[:name]} (#{currency[:iso_code]})</option>"
    end
    out << "</select></div>"
    out.html_safe
  end

  def save_multiselect(field)
    curr = " "
    if field.nil? == false
      field.each do |dc|
        curr << dc.to_s + " "
      end
    end
    curr.strip
  end
end
