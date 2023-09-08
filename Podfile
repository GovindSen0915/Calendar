# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Calendar' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
	pod 'JTAppleCalendar'
pod "FLUtilities", :git => 'https://github.com/Nickelfox/FLUtilities.git', :branch => 'develop'
    pod "FLLogs", :git => 'https://github.com/Nickelfox/FLLogs.git', :branch => 'develop'
    pod "AnyErrorKit", :git => 'https://github.com/Nickelfox/AnyErrorKit.git'
pod 'ReactiveSwift'

  # Pods for Calendar

end


#post_install do |installer|
#  installer.pods_project.targets.each do |target|
#    target.build_configurations.each do |config|
#      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
#    end
#  end
#end

post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      end
    end
  end
