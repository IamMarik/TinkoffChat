# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'TinkoffChat' do
 
  use_frameworks!
  pod 'Firebase/Firestore'
  pod 'SwiftLint'

end

target 'TinkoffChatTests' do
  
  pod 'Firebase/Firestore'

end



post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
