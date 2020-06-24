# Get the deployed git revision to display in the footer
module Git
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
