#
# Be sure to run `pod lib lint CJBAdvancedUIImage.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CJBAdvancedUIImage'
  s.version          = '1.0.1'
  s.summary          = 'CJBAdvancedUIImage is a lightweight UIImage extension that allows additional features to UIImage.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
CJBAdvancedUIImage is a lightweight UIImage extension that allows additional features such as resizing and compression to ease image requirements and handling with regards to networking and display.
DESC

s.homepage         = 'https://github.com/CJonesBuild/CJBAdvancedUIImage'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Chris Jones' => '' }
s.source           = { :git => 'https://github.com/CJonesBuild/CJBAdvancedUIImage.git', :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'CJBAdvancedUIImage/Classes/**/*'
  
  # s.resource_bundles = {
  #   'CJBAdvancedUIImage' => ['CJBAdvancedUIImage/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
