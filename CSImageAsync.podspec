#
#  Be sure to run `pod spec lint CSImageAsync.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "CSImageAsync"
  spec.version      = "1.0.0"
  spec.summary      = "A small framework written in Swift for downloading images from the web."
  spec.description  = <<-DESC
                      CSImageAsync is a Swift implementaion of an async image loader with caching achieved by NSCache.
                      DESC
  spec.homepage     = "https://github.com/charleshs/CSImageAsync"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "charleshs" => "charlous167@gmail.com" }
  spec.platform     = :ios, "12.0"
  spec.source       = { :git => "https://github.com/charleshs/CSImageAsync.git", :tag => "#{spec.version}" }
  spec.source_files  = "CSImageAsync/Source/*.{swift}"
  spec.swift_version = "5.0"
end
