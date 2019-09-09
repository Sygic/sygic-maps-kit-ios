#
# Be sure to run `pod lib lint SygicMapsKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SygicMapsKit'
  s.version          = '3.0.0'
  s.summary          = 'Library based on SygicMaps SDK. It provides ready to use components to build map-based application. Example app included.'
  s.swift_version    = '4.2'

  s.description      = <<-DESC
	A powerful open-source library based on Sygic Maps SDK which can be used to display rich map content and interact with it. It is using UI components from Sygic UI Kit.
                       DESC

  s.homepage         = 'https://github.com/Sygic/sygic-maps-kit-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sygic' => 'info@sygic.com' }
  s.source           = { :git => 'https://github.com/Sygic/sygic-maps-kit-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'SygicMapsKit/Classes/**/*'
  s.resources = 'SygicMapsKit/Resources/**/*.{xcassets}'

  s.dependency 'SygicMaps', '~> 14.0'
  s.dependency 'SygicUIKit', '~> 3.0'

  s.xcconfig = {
    'VALID_ARCHS' =>  'arm64 x86_64',
  }

end
