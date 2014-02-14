Gem::Specification.new do |s|
  s.name         = 'quickbasemapper'
  s.version      = '1.0.5'
  s.date         = '2012-07-03'
  s.summary      = "AR-like library for interacting with QuickBase"
  s.description  = "AR-like library for interacting with QuickBase"
  s.authors      = ["AIS"]
  s.email        = 'khensel@advantagequickbase.com'
  s.files        = ["lib/quickbasemapper.rb"]
  s.homepage     = 'http://www.advantageintegratedsolutions.com'
  
  s.add_dependency 'ipp_quickbase_devkit'
  s.add_dependency 'gmail'
  s.add_dependency 'tlsmail'
  
  s.add_runtime_dependency 'ipp_quickbase_devkit'
  s.add_runtime_dependency 'gmail'
  s.add_runtime_dependency 'tlsmail'
end