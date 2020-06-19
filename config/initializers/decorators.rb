
files = Dir.glob("#{Rails.root}/app/decorators/**/**/*.rb")

files.each do |f|
  require f
end
