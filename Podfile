# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'KintetsuInfo' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
pod 'RealmSwift'
pod "KRProgressHUD" 
pod 'AutoScrollLabel'
pod 'Ji', '~> 5.0.0'
  # Pods for KintetsuInfo

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end
end