Pod::Spec.new do |s|
  s.name         = "WilsonDiry"
  s.version      = "0.0.1"
  s.summary      = "It's wilson framework"
  s.homepage     = "https://github.com/MrWilsonXu/WilsonDiary"
  s.license      = "Apache License, Version 2.0"
  s.authors      = { "Wilson" => "hrxspp@126.com" }
  s.platform     = :ios, "9.0"
  s.requires_arc = true
  s.source       = { :git => "https://github.com/MrWilsonXu/WilsonDiary.git", :tag => s.version } 
  s.source_files  = "WilsonDev/WilsonDev/Container/*.{h,m}"

  # s.public_header_files = "Classes/**/*.h"


  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #s.xcconfig = { "HEADER_SEARCH_PATHS" => "${PODS_ROOT}/Headers/Public","${PODS_ROOT}/Headers/Public/AFNetworking","${PODS_ROOT}/Headers/Public/Masonry","${PODS_ROOT}/Headers/Public/Realm","${PODS_ROOT}/Headers/Public/SDAutoLayout" }
 #s.dependency	 "SDAutoLayout", "~> 2.2.0"

end
