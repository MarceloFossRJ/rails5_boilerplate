class ExcludedSubdomains
  def self.subdomains
    #%w{www admin administrator root f055 test public private staging app web net}
    ['www', 'admin', 'administrator', 'root', 'f055', 'test', 'public', 'private', 'staging', 'app', 'web', 'net']
  end
end