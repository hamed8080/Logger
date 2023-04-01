
Pod::Spec.new do |s|

  s.name         = "Logger"
  s.version      = "1.0.0"
  s.summary      = "Logger SDK"
  s.description  = "Logging on a server or device in a unified manner."
  s.homepage     = "https://github.com/hamed8080/logger"
  s.license      = "MIT"
  s.author       = { "Hamed Hosseini" => "hamed8080@gmail.com" }
  s.platform     = :ios, "10.0"
  s.swift_versions = "4.0"
  s.source       = { :git => "https://github.com/hamed8080/logger.git", :tag => s.version }
  s.source_files = "Sources/Logger/**/*.{h,swift,xcdatamodeld,m,momd}"
  s.resources = "Sources/Logger/Resources/*.xcdatamodeld"
  s.frameworks  = "Foundation" , "CoreData"

end
