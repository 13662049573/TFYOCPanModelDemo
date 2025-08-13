

Pod::Spec.new do |spec|

  spec.name         = "TFYOCPanlModel"

  spec.version      = "1.0.14"

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
    - 重构为framework架构，提升性能和稳定性
    - 修复安装后显示源码文件的问题，现在正确显示framework结构
    - 优化podspec配置，解决验证错误
    - 修正为静态库配置，解决framework加载问题
  DESC

  spec.homepage     = "https://github.com/13662049573/TFYOCPanModelDemo"
  
  spec.platform     = :ios, "15.0"
  spec.ios.deployment_target = "15.0"

  spec.license      = "MIT"
  
  spec.author       = { "tianfengyou" => "420144542@qq.com" }
  
  spec.source       = { :git => "https://github.com/13662049573/TFYOCPanModelDemo.git", :tag => spec.version }

  # 指定framework文件，这样安装后就会显示framework结构
  spec.vendored_frameworks = "TFYOCPanModelDemo/TFYOCPanlModel.framework"
  
  # 指定framework的模块映射文件
  spec.module_map = "TFYOCPanModelDemo/TFYOCPanlModel.framework/Modules/module.modulemap"

  # 依赖库
  spec.frameworks = "Foundation", "UIKit", "CoreGraphics", "QuartzCore"
  
  # 编译设置 - 静态库配置
  spec.pod_target_xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/TFYOCPanlModel',
    'OTHER_LDFLAGS' => '-framework TFYOCPanlModel',
    'DEFINES_MODULE' => 'YES',
    'VALID_ARCHS' => 'arm64',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64',
    'ENABLE_BITCODE' => 'NO',
    'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES'
  }
  
  # 用户目标配置 - 静态库配置
  spec.user_target_xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/TFYOCPanlModel',
    'OTHER_LDFLAGS' => '-framework TFYOCPanlModel',
    'VALID_ARCHS' => 'arm64',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64',
    'ENABLE_BITCODE' => 'NO',
    'ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES' => 'NO'
  }

  # 确保framework正确保留
  spec.preserve_paths = "TFYOCPanModelDemo/TFYOCPanlModel.framework"
  
  # 设置为静态库（根据扫描结果确认）
  spec.static_framework = true

end
