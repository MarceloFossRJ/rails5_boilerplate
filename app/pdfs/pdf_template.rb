class PdfTemplate < Prawn::Document
  # `include` instead of subclassing Prawn::Document as advised by the official manual
  #include Prawn::View

  # Often-Used Constants
  TABLE_ROW_COLORS = ["FFFFFF","DDDDDD"]
  TABLE_FONT_SIZE = 9
  TABLE_BORDER_STYLE = :grid
  INFO = {
      :Creator => "#{ENV["APPLICATION_NAME"]} App",
      :Producer => "Prawn",
      :CreationDate => Time.now}

  PDF_OPTIONS = {
      :info => INFO,
      :page_size   => "A4",
      :page_layout => :portrait,
      #:background  => "public/images/cert_bg.png",
      :margin      => [40, 75]
  }

  def initialize(default_options={})
    default_options ? default_prawn_options = default_options : default_prawn_options = PDF_OPTIONS
    super(default_prawn_options)
    font_size 10
  end

  def header(title=nil)
    #image "#{Rails.root}/public/logo.png", height: 30
    text "#{ENV["APPLICATION_NAME"].humanize}", size: 15, style: :bold, align: :left
    if title
      text title, size: 14, style: :bold_italic, align: :left
    end
    move_up 12
    text "Date: #{ApplicationController.helpers.format_date_time(Time.now)}", style: :normal, align: :right
    move_down 7
    stroke_horizontal_rule
    move_down 10
  end

  def footer
    # ...
  end
end
