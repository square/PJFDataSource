Pod::Spec.new do |s|
  s.name     = 'PJFDataSource'
  s.version  = '0.0.8'
  s.license  = { :type => 'Proprietary', :text => "© #{ Date.today.year } Square, Inc." }
  s.summary  = 'PJFDataSource is a small library to help with UITableView/UICollectionView/etc data source loading.'
  s.homepage = 'https://stash.corp.squareup.com/projects/IOS/repos/pjfdatasource/browse'
  s.authors  = 'Square'
  s.source   = { :git => 'https://stash.corp.squareup.com/scm/ios/pjfdatasource.git', :tag => "podify/#{ s.version.to_s }" }
  s.source_files = 'PJFDataSource/*.{h,m}'

  s.ios.deployment_target = '8.0'
end
