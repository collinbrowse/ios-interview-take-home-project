# Uncomment the next line to define a global platform for your project

platform :ios, '12.0'
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      	config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
	config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end
end

use_frameworks!

target 'Cognition Bootcamp' do
  # Comment the next line if you don't want to use dynamic frameworks
  
  # Pods for Cognition Bootcamp
  pod 'Firebase'
  pod 'FirebaseFirestoreSwift'
  pod 'Firebase/Auth'
  
  target 'Cognition BootcampTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Cognition BootcampUITests' do
    # Pods for testing
  end

end
