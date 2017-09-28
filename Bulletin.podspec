Pod::Spec.new do |s|
  s.name         = "Bulletin"
  s.version      = "0.1"
  s.summary      = "Card Interface for iOS"
  s.description  = <<-DESC
    Bulletin provides a set of tools to build card interfaces on iOS. It has a look similar to the AirPods configuration screen on iOS 10 and later. Bulletin is especially well suited for quick user interactions, such as onboardings.
  DESC
  s.homepage     = "https://github.com/alexaubry/Bulletin"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Alexis Aubry" => "me@alexaubry.fr" }
  s.social_media_url   = "https://twitter.com/_alexaubry"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/alexaubry/Bulletin.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
  s.frameworks  = "UIKit"
end
