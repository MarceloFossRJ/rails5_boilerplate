# Get the deployed git revision to display in the footer
module Git
  #REVISION = `SHA1=$(git rev-parse --short HEAD 2> /dev/null); if [ $SHA1 ]; then echo $SHA1; else echo 'unknown'; fi`.chomp
  #VERSION = `VERSION=$(git describe --tags 2> /dev/null); if [ $VERSION ]; then echo $VERSION; else echo 'unknown'; fi`.chomp

  #REVISION = File.exists?(File.join(Rails.root, 'journeyctrl_version.yml')) ? File.open(File.join(Rails.root, 'REVISION'), 'r') { |f| GIT_REVISION = f.gets.chomp } : nil
  #VERSION = File.exists?(File.join(Rails.root, 'VERSION')) ? File.open(File.join(Rails.root, 'VERSION'), 'r') { |f| GIT_VERSION = f.gets.chomp } : nil
  begin
    APP_VERSION = YAML.load(File.read("#{Rails.root}/git_version.yml"))
    VERSION = APP_VERSION["version"]
    REVISION = APP_VERSION["revision"]
  rescue
    APP_VERSION = ""
    VERSION = ""
    REVISION = ""
  end

end
#  git log -1 --format=%ai 0.3.0
#  git describe --tags