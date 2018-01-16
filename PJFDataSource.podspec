Pod::Spec.new do |s|
  s.name     = 'PJFDataSource'
  s.version  = '1.0.6'
  s.license  = 'Apache License, Version 2.0'
  s.summary  = 'A small library that provides a simple, clean architecture for your app to manage its data sources & common content view states.'
  s.homepage = 'https://github.com/square/PJFDataSource'
  s.authors  = 'Square'
  s.source   = { :git => 'https://github.com/square/PJFDataSource.git', :tag => s.version }
  s.source_files = 'PJFDataSource/*.{h,m}'
  s.ios.deployment_target = '8.0'
end
