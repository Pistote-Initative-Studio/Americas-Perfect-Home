Pod::Spec.new do |s|
  s.name             = 'leveldb-library'
  s.version          = '1.23.0'
  s.summary          = 'LevelDB is a fast key-value storage library by Google.'
  s.description      = <<-DESC
    LevelDB is a fast key-value storage library written at Google that provides
    an ordered mapping from string keys to string values.
  DESC
  s.homepage         = 'https://github.com/google/leveldb'
  s.license          = { :type => 'BSD' }
  s.authors          = 'Google'
  s.source           = { :git => 'https://github.com/google/leveldb.git', :tag => '1.23' }

  s.ios.deployment_target = '13.0'

  # ✅ Include everything in db/ and include/
  s.source_files        = 'db/**/*.{cc,h}', 'include/**/*.h'

  # ✅ Make *all* headers visible
  s.public_header_files = 'include/**/*.h', 'db/**/*.h'

  # ✅ Exclude test files
  s.exclude_files       = 'db/*_test.cc', 'db/**/*_test.cc'

  # ✅ Non-ARC
  s.requires_arc = false

  # ✅ Force header search paths
  s.pod_target_xcconfig = {
    'HEADER_SEARCH_PATHS' => '"$(PODS_ROOT)/leveldb-library/db" "$(PODS_ROOT)/leveldb-library/include"'
  }
end
