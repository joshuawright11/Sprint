
#  Be sure to run `pod spec lint Sprint.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.name = "Sprint"
  s.version = "0.1.0"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.summary = "Swift Grand Central Dispatch made easier."
  s.requires_arc = true
  s.author = { "Josh Wright" => "dev@jwright.io" }

  s.homepage = "https://github.com/joshuawright11/Sprint"

  s.source = { :git => "https://github.com/joshuawright11/Sprint.git", :tag => "#{s.version}"}

  s.source_files = "Sprint/Sprint.swift"

end
