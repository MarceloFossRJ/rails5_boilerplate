module ApplicationHelper

  #Use standard date format to all application
  # def format_date(d)
  #   d.strftime("%b %d %Y")
  # end
  def format_date(value, format=nil)
    value.try(:strftime, I18n.t(format, scope: [ :date, :formats ], default: :default))
  end

  #showing the currency symbol
  def currency_symbol
    content_tag(:span, Money.default_currency.symbol, class: "currency_symbol")
  end

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

  #master detail forms
  def link_to_add_row(name, f, association, **args)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.simple_fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize, f: builder)
    end
    link_to(name, '#', class: "add_fields " + args[:class], data: {id: id, fields: fields.gsub("\n", "")})
  end

  def link_to_add_fields(name = nil, f = nil, association = nil, options = nil, html_options = nil, &block)
    # If a block is provided there is no name attribute and the arguments are
    # shifted with one position to the left. This re-assigns those values.
    f, association, options, html_options = name, f, association, options if block_given?

    options = {} if options.nil?
    html_options = {} if html_options.nil?

    if options.include? :locals
      locals = options[:locals]
    else
      locals = { }
    end

    if options.include? :partial
      partial = options[:partial]
    else
      partial = association.to_s.singularize + '_fields'
    end

    # Render the form fields from a file with the association name provided
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, child_index: 'new_record') do |builder|
      render(partial, locals.merge!( f: builder))
    end

    # The rendered fields are sent with the link within the data-form-prepend attr
    html_options['data-form-prepend'] = raw CGI::escapeHTML( fields )
    html_options['href'] = '#'

    content_tag(:a, name, html_options, &block)
  end

end
