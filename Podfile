source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '15.0'


target 'TFYOCPanModelDemo' do
  use_frameworks!
  inhibit_all_warnings!
  
  pod 'Masonry'
  pod 'MJRefresh'
  pod 'LookinServer', :configurations => ['Debug']

  target 'TFYOCPanModelDemoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'TFYOCPanModelDemoUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "15.0"
    end
  end
end
