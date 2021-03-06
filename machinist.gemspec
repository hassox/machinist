Gem::Specification.new do |s|
  s.name         = "machinist"
  s.version      = "0.1.7.1"
  s.author       = "Pete Yandell"
  s.email        = "pete@nothat.com"
  s.homepage     = "http://github.com/notahat/machinist"
  s.summary      = "Fixtures aren't fun. Machinist is."
  s.files        = [
    "lib/machinist.rb", 
    "lib/sham.rb",
    "lib/machinist/adapters/abstract.rb",
    "lib/machinist/adapters/active_record.rb",
    "lib/machinist/adapters/datamapper.rb",
    "lib/machinist/adapters/poro.rb"
  ]
  s.require_path = "lib"
  s.has_rdoc     = false
end
