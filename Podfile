# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '14.0'

def shared
  use_frameworks!
  pod 'SnapKit', '~> 5.6.0'
  pod 'IQKeyboardManagerSwift'
end

target 'Registration' do
  shared
end

target 'RegistrationTests' do
  inherit! :search_paths
  shared
end

target 'RegistrationUITests' do
  inherit! :search_paths
end
