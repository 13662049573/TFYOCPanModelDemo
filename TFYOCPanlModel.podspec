

Pod::Spec.new do |spec|

  spec.name         = "TFYOCPanlModel"

  spec.version      = "1.0.8"

  spec.summary      = "TFYOCPanlModel：高扩展性OC弹窗组件，支持多种弹窗样式与交互。"

  spec.description  = <<-DESC
    TFYOCPanlModel 是一套高扩展性的 Objective-C 弹窗组件，支持多种弹窗样式、交互动画与自定义扩展，适用于 iOS 各类弹窗场景。
    
    主要特性：
    - 支持多种弹窗样式（全屏、半屏、购物车等）
    - 丰富的交互动画和手势支持
    - 高度可定制的UI组件
    - 支持iOS 15.0+
    - 完整的生命周期管理
    - 支持深色模式
  DESC

  spec.homepage     = "https://github.com/13662049573/TFYOCPanModelDemo"
  
  spec.platform     = :ios, "15.0"
  spec.ios.deployment_target = "15.0"

  spec.license      = "MIT"
  
  spec.author       = { "tianfengyou" => "420144542@qq.com" }
  
  spec.source       = { :git => "https://github.com/13662049573/TFYOCPanModelDemo.git", :tag => spec.version }

  # 由于这是一个framework项目，我们指定framework文件
  spec.vendored_frameworks = "TFYOCPanModelDemo/TFYOCPanlModel.framework"
  
  # 指定framework的公共头文件
  spec.public_header_files = "TFYOCPanModelDemo/TFYOCPanlModel.framework/Headers/*.h"
  
  # 指定framework的私有头文件（如果需要的话）
  spec.private_header_files = "TFYOCPanModelDemo/TFYOCPanlModel.framework/Headers/*.h"
  
  # 指定framework的模块映射文件
  spec.module_map = "TFYOCPanModelDemo/TFYOCPanlModel.framework/Modules/module.modulemap"
  
  # 指定framework的Info.plist
  spec.resource_bundles = {
    'TFYOCPanlModel' => ['TFYOCPanModelDemo/TFYOCPanlModel.framework/Info.plist']
  }

  # 依赖库
  spec.frameworks = "Foundation", "UIKit", "CoreGraphics", "QuartzCore"
  
  # 编译设置
  spec.pod_target_xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '$(PODS_ROOT)/TFYOCPanlModel',
    'OTHER_LDFLAGS' => '-framework TFYOCPanlModel',
    'DEFINES_MODULE' => 'YES',
    'SWIFT_VERSION' => '5.0'
  }
  
  # 用户目标配置
  spec.user_target_xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '$(PODS_ROOT)/TFYOCPanlModel',
    'OTHER_LDFLAGS' => '-framework TFYOCPanlModel'
  }

end
