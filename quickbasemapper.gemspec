Gem::Specification.new do |s|
  s.name         = 'quickbasemapper'
  s.version      = '0.0.7'
  s.date         = '2012-07-02'
  s.summary      = "AR-like library for interacting with QuickBase"
  s.description  = "AR-like library for interacting with QuickBase"
  s.authors      = ["Charles Grimes"]
  s.email        = 'cj@maru-creative.com'
  s.files        = ["lib/quickbasemapper.rb"]
  s.homepage     = 'http://www.advantageintegratedsolutions.com'
  s.add_dependency 'ipp_quickbase_devkit'
  s.add_runtime_dependency 'ipp_quickbase_devkit'
end