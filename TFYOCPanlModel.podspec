

Pod::Spec.new do |spec|

  spec.name         = "TFYOCPanlModel"

  spec.version      = "1.3.7"

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

  # 源码文件递归所有.h/.m
  spec.source_files  = "TFYOCPanModelDemo/TFYOCPanlModel/**/*.{h,m}"

  # 公共头文件（按文件夹结构组织）
  spec.public_header_files = [
    # 主头文件
    "TFYOCPanModelDemo/TFYOCPanlModel/TFYOCPanlModel.h",
    
    # Presentable 文件夹
    "TFYOCPanModelDemo/TFYOCPanlModel/Presentable/*.h",
    
    # Presenter 文件夹
    "TFYOCPanModelDemo/TFYOCPanlModel/Presenter/*.h",
    
    # Controller 文件夹
    "TFYOCPanModelDemo/TFYOCPanlModel/Controller/*.h",
    
    # Mediator 文件夹
    "TFYOCPanModelDemo/TFYOCPanlModel/Mediator/*.h",
    
    # Delegate 文件夹
    "TFYOCPanModelDemo/TFYOCPanlModel/Delegate/*.h",
    
    # Animator 文件夹
    "TFYOCPanModelDemo/TFYOCPanlModel/Animator/*.h",
    "TFYOCPanModelDemo/TFYOCPanlModel/Animator/PresentingVCAnimation/*.h",
    
    # View 文件夹
    "TFYOCPanModelDemo/TFYOCPanlModel/View/*.h",
    "TFYOCPanModelDemo/TFYOCPanlModel/View/PanModal/*.h",
    
    # Category 文件夹
    "TFYOCPanModelDemo/TFYOCPanlModel/Category/*.h",
    
    # KVO 文件夹
    "TFYOCPanModelDemo/TFYOCPanlModel/KVO/*.h",

    # Popup 文件夹
    "TFYOCPanModelDemo/TFYOCPanlModel/popup/*.h"
  ]

end
