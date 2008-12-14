Gem::Specification.new do |s|
  s.name         = "machinist"
  s.version      = "0.1.2.1"
  s.author       = "Pete Yandell"
  s.email        = "pete@nothat.com"
  s.homepage     = "http://github.com/notahat/machinist"
  s.summary      = "Fixtures aren't fun. Machinist is."
  s.files        = ["lib/machinist.rb", "lib/sham.rb"]
  s.add_dependency("extlib", "~> 0.9.9")
  s.add_dependency("faker",  "~> 0.3")
  s.require_path = "lib"
  s.has_rdoc     = false
end
