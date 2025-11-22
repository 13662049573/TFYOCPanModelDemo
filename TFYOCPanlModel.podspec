
Pod::Spec.new do |spec|

  spec.name         = "TFYOCPanlModel"

  spec.version      = "1.6.9"

  spec.summary      = "TFYOCPanlModel：高扩展性OC弹窗组件，支持多种弹窗样式与交互。"

  spec.description  = <<-DESC
    TFYOCPanlModel 是一套高扩展性的 Objective-C 弹窗组件，支持多种弹窗样式、交互动画与自定义扩展，适用于 iOS 各类弹窗场景。
  DESC

  spec.homepage     = "https://github.com/13662049573/TFYOCPanModelDemo"
  
  spec.platform     = :ios, "15.0"
  spec.ios.deployment_target = "15.0"

  spec.license      = "MIT"
  
  spec.author       = { "tianfengyou" => "420144542@qq.com" }
  
  spec.source       = { :git => "https://github.com/13662049573/TFYOCPanModelDemo.git", :tag => spec.version }

  # 基础路径变量 - 全局 header_search_paths，让所有 subspec 都能找到头文件
  base_path = '$(PODS_TARGET_SRCROOT)/TFYOCPanModelDemo/Sources/TFYOCPanlModel'
  header_paths = "#{base_path} #{base_path}/include #{base_path}/popController #{base_path}/popView #{base_path}/Tools"

  # ========== 第一类：无依赖的工具文件夹 ==========
  
  # Tools 工具文件夹 - 无依赖
  spec.subspec 'Tools' do |ss|
    ss.source_files  = "TFYOCPanModelDemo/Sources/TFYOCPanlModel/Tools/**/*.{h,m}"
    ss.public_header_files = "TFYOCPanModelDemo/Sources/TFYOCPanlModel/Tools/**/*.h"
    ss.pod_target_xcconfig = { 'HEADER_SEARCH_PATHS' => header_paths }
  end

  # ========== 第二类：控制弹出文件夹（popController，依赖 Tools） ==========
  
  # popController 控制弹出文件夹 - 依赖 Tools
  spec.subspec 'popController' do |ss|
    ss.source_files  = "TFYOCPanModelDemo/Sources/TFYOCPanlModel/popController/**/*.{h,m}"
    ss.public_header_files = "TFYOCPanModelDemo/Sources/TFYOCPanlModel/popController/**/*.h"
    ss.dependency "TFYOCPanlModel/Tools"
    ss.pod_target_xcconfig = { 'HEADER_SEARCH_PATHS' => header_paths }
  end

  # ========== 第三类：pop 弹出文件夹（popView，独立模块） ==========
  
  # popView pop弹出文件夹 - 独立模块，无依赖
  spec.subspec 'popView' do |ss|
    ss.source_files  = "TFYOCPanModelDemo/Sources/TFYOCPanlModel/popView/**/*.{h,m}"
    ss.public_header_files = "TFYOCPanModelDemo/Sources/TFYOCPanlModel/popView/**/*.h"
    ss.pod_target_xcconfig = { 'HEADER_SEARCH_PATHS' => header_paths }
  end

  # ========== 第四类：主头文件（include，依赖所有模块） ==========
  
  # include 主头文件 - 依赖所有核心模块
  spec.subspec 'include' do |ss|
    ss.source_files  = "TFYOCPanModelDemo/Sources/TFYOCPanlModel/include/**/*.{h,m}"
    ss.public_header_files = "TFYOCPanModelDemo/Sources/TFYOCPanlModel/include/**/*.h"
    ss.dependency "TFYOCPanlModel/popController"
    ss.dependency "TFYOCPanlModel/popView"
    # include 需要访问 popController 和 popView 的头文件
    # 使用 header_search_paths 确保能找到依赖模块的头文件
    ss.pod_target_xcconfig = { 
      'HEADER_SEARCH_PATHS' => header_paths,
      'USER_HEADER_SEARCH_PATHS' => "#{base_path}/popController #{base_path}/popView"
    }
  end

  spec.requires_arc = true

end
