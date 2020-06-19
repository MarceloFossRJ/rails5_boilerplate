module FormatHelper

  #Use standard date format to all application
  def format_date(value, format=nil)
    value.try(:strftime, "%d/%m/%Y")
  end

  #Use standard date format to all application
  def format_date_iso(value, format=nil)
    value.try(:strftime, "%Y-%m-%d")
  end

  #Use standard date_time format to all application
  def format_date_time(value, format=nil)
    value.try(:strftime, "%d/%m/%Y %H:%Mhs %Ss")
  end

  #showing the currency symbol
  def currency_symbol
    content_tag(:span, Money.default_currency.symbol, class: "currency_symbol")
  end

end