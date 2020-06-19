module TypographyHelper
  def header_h1(text, classe=nil)
    out = "<div class='form-element-align'>"
    out << "<h1 class='#{classe}'>#{text}</h1>"
    out << "</div>"
    out.html_safe
  end
  def header_h2(text, classe=nil)
    out = "<div class='form-element-align'>"
    out << "<h2 class='#{classe}'>#{text}</h2>"
    out << "</div>"
    out.html_safe
  end
  def header_h3(text, classe=nil)
    out = "<div class='form-element-align'>"
    out << "<h3 class='#{classe}'>#{text}</h3>"
    out << "</div>"
    out.html_safe
  end
  def header_h4(text, classe=nil)
    out = "<div class='form-element-align'>"
    out << "<h4 class='#{classe}'>#{text}</h4>"
    out << "</div>"
    out.html_safe
  end
  def header_h5(text, classe=nil)
    out = "<div class='form-element-align'>"
    out << "<h5 class='#{classe}'>#{text}</h5>"
    out << "</div>"
    out.html_safe
  end
  def header_h6(text, classe=nil)
    out = "<div class='form-element-align'>"
    out << "<h6 class='#{classe}'>#{text}</h6>"
    out << "</div>"
    out.html_safe
  end
end